import 'dart:async';
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
///   - Manage video and screen sharing tracks
///   - Clean disconnect on stream end
///
/// Note on types: livekit_client 2.x removed the concrete
/// `RemoteAudioTrackPublication` class.  Track publications are now
/// `RemoteTrackPublication<RemoteTrack>` and the track kind is checked
/// via `track is RemoteAudioTrack`.
class MediaService {
  MediaService();

  Room? _room;
  EventsListener<RoomEvent>? _listener;
  LocalAudioTrack? _localAudioTrack;

  // Stream controllers for various events
  final _remoteAudioController = StreamController<RemoteAudioTrack>.broadcast();
  final _participantJoinedController =
      StreamController<RemoteParticipant>.broadcast();
  final _participantLeftController =
      StreamController<RemoteParticipant>.broadcast();
  final _speakingController = StreamController<List<Participant>>.broadcast();
  final _activeSpeakersController =
      StreamController<List<Participant>>.broadcast();
  final _mediaStateController = StreamController<MediaStateChange>.broadcast();

  // ── Public streams ─────────────────────────────────────────────────────

  /// Fires whenever a remote audio track is subscribed (attach to widget).
  Stream<RemoteAudioTrack> get onRemoteAudioTrack =>
      _remoteAudioController.stream;

  /// Fires when a participant joins the room.
  Stream<RemoteParticipant> get onParticipantJoined =>
      _participantJoinedController.stream;

  /// Fires when a participant leaves the room.
  Stream<RemoteParticipant> get onParticipantLeft =>
      _participantLeftController.stream;

  /// Fires with the current list of speaking participants (active speakers).
  Stream<List<Participant>> get onSpeaking => _speakingController.stream;

  /// Fires with the current list of active speakers (for UI highlighting).
  Stream<List<Participant>> get onActiveSpeakers =>
      _activeSpeakersController.stream;

  /// Fires when any participant's media state changes (mute/unmute, video on/off).
  Stream<MediaStateChange> get onMediaStateChanged =>
      _mediaStateController.stream;

  bool get isConnected =>
      _room != null && _room!.connectionState == ConnectionState.connected;

  /// The underlying room, useful for reading [remoteParticipants] directly.
  Room? get room => _room;

  /// The local participant (current user)
  LocalParticipant? get localParticipant => _room?.localParticipant;

  /// Check if local audio is enabled
  bool get isAudioEnabled => localParticipant?.isMicrophoneEnabled() ?? false;

  /// Check if local video is enabled
  bool get isVideoEnabled => localParticipant?.isCameraEnabled() ?? false;

  // ── Connect ────────────────────────────────────────────────────────────

  /// Connects to the LiveKit room.
  ///
  /// [token]      – JWT from POST /api/v1/livestreams/{id}/token
  /// [url]        – wss://... LiveKit server URL from the same response
  /// [isSpeaker]  – pass true for host / pre-approved speakers so
  ///                the microphone is published immediately on connect
  Future<void> connect({
    required String url,
    required String token,
    bool isSpeaker = false,
  }) async {
    _room = Room();
    _listener = _room!.createListener();
    _registerRoomEvents();

    developer.log('Connecting to LiveKit room', name: 'MediaService');

    try {
      await _room!.connect(
        url,
        token,
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
          defaultAudioPublishOptions: AudioPublishOptions(
            name: 'microphone',
            audioBitrate: 32000,
          ),
        ),
      );

      // if (defaultTargetPlatform == TargetPlatform.android) {
      //   developer.log("Setting speakerphone on");
      //   await Hardware.instance.setSpeakerphoneOn(true);
      //   await Hardware.instance.setPreferSpeakerOutput(true);
      // }

      log(
        'Connected to LiveKit room successfully',
      );

      // ── Media Snapshot ──────────────────────────────────────────────────
      // Attach any remote audio tracks that were already present when we
      // joined (the guide's "Media Snapshot" step).
      for (final participant in _room!.remoteParticipants.values) {
        _processExistingTracks(participant);
      }

      // Initial active speakers might already be set
      final activeSpeakers = _room!.activeSpeakers;
      if (activeSpeakers.isNotEmpty) {
        _activeSpeakersController.add(activeSpeakers);
      }

      await setupAndPublishAudio();
      await toggleMicrophone(isSpeaker);
    } catch (e) {
      developer.log('Failed to connect to LiveKit: $e',
          name: 'MediaService', level: 1000);
      rethrow;
    }
  }

  // ── Media publishing / unpublishing ─────────────────────────────────────
  Future<void> setupAndPublishAudio() async {
    // Don't publish if already published
    if (_localAudioTrack != null) {
      log('Audio track already published');
      return;
    }

    try {
      _localAudioTrack = await LocalAudioTrack.create();
      await _room!.localParticipant?.publishAudioTrack(
        _localAudioTrack!,
        publishOptions: const AudioPublishOptions(
          name: 'microphone',
        ),
      );
      log('Audio track published successfully');
    } catch (e) {
      log('Mic setup failed: $e', level: LogLevel.warn);
    }
  }

  /// Called when a hand-raise is approved and `is_speaker` becomes true.
  Future<void> toggleMicrophone(bool enable) async {
    if (_room == null) return;
    if (_localAudioTrack == null) {
      log('Audio track not published yet, skipping toggle');
      return;
    }
    try {
      await _room!.localParticipant?.setMicrophoneEnabled(enable);
      log("Toggling mic to $enable");
    } catch (e) {
      developer.log('Failed to toggle microphone: $e',
          name: 'MediaService', level: 1000);
      rethrow;
    }
  }

  Future<void> toggleMute() async {
    final lp = _room?.localParticipant;
    if (lp == null) return;
    final current = lp.isMicrophoneEnabled();
    await lp.setMicrophoneEnabled(!current);
    developer.log('Audio toggled: ${!current}', name: 'MediaService');
  }

  // ── Disconnect ─────────────────────────────────────────────────────────

  Future<void> disconnect() async {
    log('Disconnecting MediaService');
    // Clean up local track
    await _localAudioTrack?.dispose();
    _localAudioTrack = null;

    await _localAudioTrack?.dispose();
    _localAudioTrack = null;

    _listener?.dispose();
    _listener = null;
    await _room?.disconnect();
    _room = null;

    log(
      'MediaService disconnected',
    );
  }

  void dispose() {
    disconnect();
    _remoteAudioController.close();
    _participantJoinedController.close();
    _participantLeftController.close();
    _speakingController.close();
    _activeSpeakersController.close();
    _mediaStateController.close();
  }

  // ── Room event wiring ──────────────────────────────────────────────────

  void _registerRoomEvents() {
    _listener!
      ..on<TrackSubscribedEvent>(_onTrackSubscribed)
      ..on<ParticipantConnectedEvent>(_onParticipantConnected)
      ..on<ParticipantDisconnectedEvent>(_onParticipantDisconnected)
      ..on<ActiveSpeakersChangedEvent>(_onActiveSpeakersChanged)
      ..on<RoomEvent>((event) {
        // Log unhandled events for debugging
        log('Unhandled room event: ${event.runtimeType}', level: LogLevel.warn);
      });
  }

  void _onTrackSubscribed(TrackSubscribedEvent event) {
    log('Track subscribed: ${event.track.kind}');
    final track = event.track;
    final participant = event.participant;

    if (track is RemoteAudioTrack) {
      log('Remote audio track received!');
      _remoteAudioController.add(track);
      _emitMediaStateChange(participant.identity, MediaType.audio, true);
    }
  }

  void _onParticipantConnected(ParticipantConnectedEvent event) {
    final participant = event.participant;
    _participantJoinedController.add(participant);

    // Process existing tracks for this participant
    _processExistingTracks(participant);

    developer.log('Participant joined: ${participant.identity}',
        name: 'MediaService');
  }

  void _onParticipantDisconnected(ParticipantDisconnectedEvent event) {
    final participant = event.participant;
    _participantLeftController.add(participant);

    developer.log('Participant left: ${participant.identity}',
        name: 'MediaService');
  }

  void _onActiveSpeakersChanged(ActiveSpeakersChangedEvent event) {
    _speakingController.add(event.speakers);
    _activeSpeakersController.add(event.speakers);
  }

  void _processExistingTracks(Participant participant) {
    // Process audio tracks
    for (final pub in participant.audioTrackPublications) {
      final track = pub.track;
      if (pub.subscribed && track is RemoteAudioTrack) {
        _remoteAudioController.add(track);
        _emitMediaStateChange(participant.identity, MediaType.audio, true);
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

  void log(String message, {LogLevel level = LogLevel.debug}) {
    developer.log(message, name: 'MediaService', level: level.value);
  }
}
