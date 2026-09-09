import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer show log;
import 'package:livekit_client/livekit_client.dart';

import '../../config/config_export.dart';
import '../models/livestream_models.dart';

/// Manages the **Media Plane** LiveKit room connection.
///
/// Responsibilities:
///   - Connect to the LiveKit room with the JWT from /token
///   - Attach existing remote audio tracks on join (sync snapshot)
///   - Expose streams for participant join/leave and track events
///   - Publish / unpublish the local audio track when the user is
///     promoted to speaker
///   - Clean disconnect on stream end
class MediaService {
  MediaService();

  Room? _room;
  EventsListener<RoomEvent>? _listener;
  LocalAudioTrack? _localAudioTrack;

  bool _disposed = false;

  final StreamController<RemoteAudioTrack> _remoteAudioController = StreamController<RemoteAudioTrack>.broadcast();
  final StreamController<RemoteParticipant> _participantJoinedController =
  StreamController<RemoteParticipant>.broadcast();
  final StreamController<RemoteParticipant> _participantLeftController =
  StreamController<RemoteParticipant>.broadcast();
  final StreamController<List<Participant<TrackPublication<Track>>>> _activeSpeakersController =
  StreamController<List<Participant>>.broadcast();
  final StreamController<MediaStateChange> _mediaStateController = StreamController<MediaStateChange>.broadcast();

  // ── Public streams ─────────────────────────────────────────────────────

  Stream<RemoteAudioTrack> get onRemoteAudioTrack =>
      _remoteAudioController.stream;

  Stream<RemoteParticipant> get onParticipantJoined =>
      _participantJoinedController.stream;

  Stream<RemoteParticipant> get onParticipantLeft =>
      _participantLeftController.stream;

  /// Fires with the current list of active speakers (for UI highlighting).
  Stream<List<Participant>> get onActiveSpeakers =>
      _activeSpeakersController.stream;

  /// Fires when any participant's media state changes (mute/unmute, etc.).
  Stream<MediaStateChange> get onMediaStateChanged =>
      _mediaStateController.stream;

  bool get isConnected =>
      _room != null && _room!.connectionState == ConnectionState.connected;

  Room? get room => _room;

  LocalParticipant? get localParticipant => _room?.localParticipant;

  bool get isAudioEnabled => localParticipant?.isMicrophoneEnabled() ?? false;

  // ── Connect ────────────────────────────────────────────────────────────

  /// Connects to the LiveKit room.
  ///
  /// [token]      – JWT from POST /api/v1/livestreams/{id}/token
  /// [url]        – wss://... LiveKit server URL
  /// [isSpeaker]  – pass true for host / pre-approved speakers so the
  ///                microphone is enabled immediately on connect
  Future<void> connect({
    required String url,
    required String token,
    bool isSpeaker = false,
  }) async {
    _room = Room(
      roomOptions: const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        defaultAudioPublishOptions: AudioPublishOptions(
          name: 'microphone',
          audioBitrate: 32000,
        ),
      ),
    );
    _listener = _room!.createListener();
    _registerRoomEvents();

    _log('Connecting to LiveKit room');

    try {
      await _room!.connect(
        url,
        token,
      );

      _log('Connected to LiveKit room successfully');

      // ── Media Snapshot ────────────────────────────────────────────────
      // Attach any remote audio tracks already present when joining.
      for (final RemoteParticipant participant in _room!.remoteParticipants.values) {
        _processExistingTracks(participant);
      }

      // Emit initial active speakers if any.
      final UnmodifiableListView<Participant<TrackPublication<Track>>> activeSpeakers = _room!.activeSpeakers;
      if (activeSpeakers.isNotEmpty) {
        _activeSpeakersController.add(activeSpeakers);
      }

      // Always publish the audio track; only enable the mic if isSpeaker.
      await setupAndPublishAudio();
      await toggleMicrophone(isSpeaker);
    } catch (e) {
      _log('Failed to connect to LiveKit: $e', level: LogLevel.error);
      rethrow;
    }
  }

  // ── Media publishing ───────────────────────────────────────────────────

  /// Creates and publishes the local audio track (muted by default).
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> setupAndPublishAudio() async {
    if (_localAudioTrack != null) {
      _log('Audio track already published, skipping');
      return;
    }

    try {
      _localAudioTrack = await LocalAudioTrack.create();
      await _room!.localParticipant?.publishAudioTrack(
        _localAudioTrack!,
        publishOptions: const AudioPublishOptions(name: 'microphone'),
      );
      _log('Audio track published successfully');
    } catch (e) {
      _log('Mic setup failed: $e', level: LogLevel.warn);
    }
  }

  /// Enables or disables the microphone for the local participant.
  Future<void> toggleMicrophone(bool enable) async {
    if (_room == null) return;
    if (_localAudioTrack == null) {
      _log('Audio track not published yet, skipping toggle');
      return;
    }
    try {
      await _room!.localParticipant?.setMicrophoneEnabled(enable);
      _log('Microphone set to: $enable');
    } catch (e) {
      _log('Failed to toggle microphone: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Toggles the local microphone between enabled and disabled.
  Future<void> toggleMute() async {
    final LocalParticipant? lp = _room?.localParticipant;
    if (lp == null) return;
    final bool current = lp.isMicrophoneEnabled();
    await lp.setMicrophoneEnabled(!current);
    _log('Audio toggled: ${!current}');
  }

  // ── Disconnect ─────────────────────────────────────────────────────────

  /// Disconnects the room and releases all resources.
  /// Safe to call multiple times.
  Future<void> disconnect() async {
    _log('Disconnecting MediaService');

    await _localAudioTrack?.dispose();
    _localAudioTrack = null;

    _listener?.dispose();
    _listener = null;

    await _room?.disconnect();
    _room = null;

    _log('MediaService disconnected');
  }

  /// Disconnects and closes all stream controllers.
  /// Call this only when the service will no longer be used.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;

    await disconnect();

    _remoteAudioController.close();
    _participantJoinedController.close();
    _participantLeftController.close();
    _activeSpeakersController.close();
    _mediaStateController.close();
  }

  // ── Room event wiring ──────────────────────────────────────────────────

  void _registerRoomEvents() {
    _listener!
      ..on<TrackSubscribedEvent>(_onTrackSubscribed)
      ..on<ParticipantConnectedEvent>(_onParticipantConnected)
      ..on<ParticipantDisconnectedEvent>(_onParticipantDisconnected)
      ..on<ActiveSpeakersChangedEvent>(_onActiveSpeakersChanged);
  }

  void _onTrackSubscribed(TrackSubscribedEvent event) {
    final Track track = event.track;
    final RemoteParticipant participant = event.participant;

    if (track is RemoteAudioTrack) {
      _log('Remote audio track subscribed from ${participant.identity}');
      _remoteAudioController.add(track);
      _emitMediaStateChange(participant.identity, MediaType.audio, !track.muted);
    }
  }

  void _onParticipantConnected(ParticipantConnectedEvent event) {
    final RemoteParticipant participant = event.participant;
    _log('Participant joined: ${participant.identity}');
    _participantJoinedController.add(participant);
    _processExistingTracks(participant);
  }

  void _onParticipantDisconnected(ParticipantDisconnectedEvent event) {
    _log('Participant left: ${event.participant.identity}');
    _participantLeftController.add(event.participant);
  }

  void _onActiveSpeakersChanged(ActiveSpeakersChangedEvent event) {
    _activeSpeakersController.add(event.speakers);
  }

  void _processExistingTracks(RemoteParticipant participant) {
    for (final RemoteTrackPublication<RemoteAudioTrack> pub in participant.audioTrackPublications) {
      final RemoteAudioTrack? track = pub.track;
      if (pub.subscribed && track is RemoteAudioTrack) {
        _remoteAudioController.add(track);
        _emitMediaStateChange(participant.identity, MediaType.audio, !track.muted);
      }
    }
  }

  void _emitMediaStateChange(String identity, MediaType type, bool enabled) {
    _mediaStateController.add(MediaStateChange(
      identity: identity,
      type: type,
      enabled: enabled,
    ));
  }

  void _log(String message, {LogLevel level = LogLevel.debug}) {
    developer.log(message, name: 'MediaService', level: level.value);
  }
}