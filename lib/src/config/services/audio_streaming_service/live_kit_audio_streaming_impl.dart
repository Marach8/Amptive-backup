import 'dart:async';
import 'package:amptive/src/config/services/audio_streaming_service/audio_streaming_service.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';

class LiveKitAudioStreamingService implements ATAudioStreamingService {
  final Room _room = Room();

  final StreamController<List<LiveSessionParticipant>> _participantsController =
      StreamController<List<LiveSessionParticipant>>.broadcast();

  final StreamController<LiveSessionConnectionStatus> _connectionController =
      StreamController<LiveSessionConnectionStatus>.broadcast();

  final StreamController<List<String>> _activeSpeakersController =
      StreamController<List<String>>.broadcast();

  CancelListenFunc? _roomSub;

  // ---------------------------------------------------------------------------
  // CONNECT
  // ---------------------------------------------------------------------------

  @override
  Future<void> connect({
    required String roomUrl,
    required String participantToken,
  }) async {
    _connectionController.add(LiveSessionConnectionStatus.connecting);

    await _room.connect(roomUrl, participantToken);

    _connectionController.add(LiveSessionConnectionStatus.connected);

    _listenToEvents();
    _emitParticipants();
  }

  // ---------------------------------------------------------------------------
  // DISCONNECT
  // ---------------------------------------------------------------------------

  @override
  Future<void> disconnect() async {
    await _room.disconnect();
    _connectionController.add(LiveSessionConnectionStatus.disconnected);
  }

  // ---------------------------------------------------------------------------
  // MIC CONTROL
  // ---------------------------------------------------------------------------

  @override
  Future<void> setMicEnabled(bool enabled) async {
    await _room.localParticipant?.setMicrophoneEnabled(enabled);
    _emitParticipants();
  }

  @override
  Future<void> toggleMic() async {
    final bool current = _room.localParticipant?.isMicrophoneEnabled() ?? false;
    await setMicEnabled(!current);
  }

  // ---------------------------------------------------------------------------
  // STREAMS
  // ---------------------------------------------------------------------------

  @override
  Stream<List<LiveSessionParticipant>> get participantsStream =>
      _participantsController.stream;

  @override
  Stream<LiveSessionConnectionStatus> get connectionStateStream =>
      _connectionController.stream;

  @override
  Stream<List<String>> get activeSpeakersStream =>
      _activeSpeakersController.stream;

  // ---------------------------------------------------------------------------
  // EVENTS
  // ---------------------------------------------------------------------------

  void _listenToEvents() {
    _roomSub?.call();

    _roomSub = _room.events.listen((RoomEvent event) {
      if (event is ParticipantConnectedEvent ||
          event is ParticipantDisconnectedEvent ||
          event is TrackMutedEvent ||
          event is TrackUnmutedEvent) {
        _emitParticipants();
      }

      if (event is ActiveSpeakersChangedEvent) {
        final List<String> speakers = event.speakers.map((s) => s.identity).toList();
        _activeSpeakersController.add(speakers);

        _emitParticipants(
          audioLevels: <String, double>{
            for (final Participant<TrackPublication<Track>> s in event.speakers)
              if (s.identity.isNotEmpty)
                s.identity: s.audioLevel,
          },
        );
      }

      if (event is RoomDisconnectedEvent) {
        _connectionController.add(LiveSessionConnectionStatus.disconnected);
      }

      if (event is RoomReconnectingEvent) {
        _connectionController.add(LiveSessionConnectionStatus.reconnecting);
      }

      if (event is RoomReconnectedEvent) {
        _connectionController.add(LiveSessionConnectionStatus.connected);
        _emitParticipants();
      }
    });
  }

  // ---------------------------------------------------------------------------
  // PARTICIPANT MAPPING
  // ---------------------------------------------------------------------------

  void _emitParticipants({Map<String, double>? audioLevels}) {
    final Map<String, LiveSessionParticipant> updated =
        <String, LiveSessionParticipant>{};

    final LocalParticipant? local = _room.localParticipant;
    if (local != null) {
      updated[local.identity] = _mapParticipant(
        local,
        isLocal: true,
        audioLevel: audioLevels?[local.identity] ?? 0.0,
      );
    }

    for (final RemoteParticipant p in _room.remoteParticipants.values) {
      updated[p.identity] = _mapParticipant(
        p,
        isLocal: false,
        audioLevel: audioLevels?[p.identity] ?? 0.0,
      );
    }

    _participantsController.add(updated.values.toList());
  }

  LiveSessionParticipant _mapParticipant(
    Participant p, {
    required bool isLocal,
    double audioLevel = 0.0,
  }) {
    final TrackPublication? audioPub = p.audioTrackPublications.firstOrNull;

    return LiveSessionParticipant(
      isMuted: audioPub?.muted ?? true,
      isSpeaking: p.isSpeaking,
      isLocal: isLocal,
      audioLevel: audioLevel,
      name: p.name,
      username: p.name,
      roomParticipantId: p.identity,
    );
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  @override
  Future<void> dispose() async {
    await _roomSub?.call();
    await _participantsController.close();
    await _connectionController.close();
    await _activeSpeakersController.close();
    await _room.dispose();
  }
}
