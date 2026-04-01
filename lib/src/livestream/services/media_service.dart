import 'dart:async';
import 'dart:developer' as developer show log;
import 'package:livekit_client/livekit_client.dart';

/// Manages the **Media Plane** LiveKit room connection.
///
/// Responsibilities:
///   - Connect to the LiveKit room with the JWT from /token
///   - Attach existing remote audio tracks on join (sync snapshot)
///   - Expose streams for participant join/leave and track events
///   - Publish / unpublish the local audio track when the user is
///     promoted to speaker
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

  // Emits the RemoteAudioTrack itself so callers never need to touch
  // the publication generic directly.
  final _remoteAudioController =
  StreamController<RemoteAudioTrack>.broadcast();
  final _participantJoinedController =
  StreamController<RemoteParticipant>.broadcast();
  final _participantLeftController =
  StreamController<RemoteParticipant>.broadcast();
  final _speakingController =
  StreamController<List<Participant>>.broadcast();

  // ── Public streams ─────────────────────────────────────────────────────

  /// Fires whenever a remote audio track is subscribed (attach to widget).
  Stream<RemoteAudioTrack> get onRemoteAudioTrack =>
      _remoteAudioController.stream;

  Stream<RemoteParticipant> get onParticipantJoined =>
      _participantJoinedController.stream;

  Stream<RemoteParticipant> get onParticipantLeft =>
      _participantLeftController.stream;

  /// Fires with the current list of active speakers.
  Stream<List<Participant>> get onActiveSpeakers =>
      _speakingController.stream;

  bool get isConnected =>
      _room != null &&
          _room!.connectionState == ConnectionState.connected;

  /// The underlying room, useful for reading [remoteParticipants] directly.
  Room? get room => _room;

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

    // ── Media Snapshot ──────────────────────────────────────────────────
    // Attach any remote audio tracks that were already present when we
    // joined (the guide's "Media Snapshot" step).
    for (final participant in _room!.remoteParticipants.values) {
      for (final pub in participant.audioTrackPublications) {
        final track = pub.track;
        if (pub.subscribed && track is RemoteAudioTrack) {
          _remoteAudioController.add(track);
        }
      }
    }

    if (isSpeaker) await publishAudio();
  }

  // ── Audio publish / unpublish ──────────────────────────────────────────

  /// Called when a hand-raise is approved and `is_speaker` becomes true.
  Future<void> publishAudio() async {
    if (_room == null) return;
    await _room!.localParticipant?.setMicrophoneEnabled(true);
  }

  Future<void> unpublishAudio() async {
    if (_room == null) return;
    await _room!.localParticipant?.setMicrophoneEnabled(false);
  }

  Future<void> toggleMute() async {
    final lp = _room?.localParticipant;
    if (lp == null) return;
    final current = lp.isMicrophoneEnabled();
    await lp.setMicrophoneEnabled(!current);
  }

  // ── Disconnect ─────────────────────────────────────────────────────────

  Future<void> disconnect() async {
    _listener?.dispose();
    _listener = null;
    await _room?.disconnect();
    _room = null;
  }

  void dispose() {
    disconnect();
    _remoteAudioController.close();
    _participantJoinedController.close();
    _participantLeftController.close();
    _speakingController.close();
  }

  // ── Room event wiring ──────────────────────────────────────────────────

  void _registerRoomEvents() {
    _listener!
      ..on<TrackSubscribedEvent>(_onTrackSubscribed)
      ..on<ParticipantConnectedEvent>((e) {
        _participantJoinedController.add(e.participant);
      })
      ..on<ParticipantDisconnectedEvent>((e) {
        _participantLeftController.add(e.participant);
      })
      ..on<ActiveSpeakersChangedEvent>((e) {
        _speakingController.add(e.speakers);
      });
  }

  void _onTrackSubscribed(TrackSubscribedEvent event) {
    // event.track is the base Track type; narrow to RemoteAudioTrack.
    final track = event.track;
    if (track is RemoteAudioTrack) {
      _remoteAudioController.add(track);
    }
  }
}