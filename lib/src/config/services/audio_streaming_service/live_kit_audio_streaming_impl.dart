import 'dart:async';
import 'dart:developer' show log;
import 'package:amptive/src/config/services/audio_streaming_service/audio_streaming_service.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';

class LiveKitAudioStreamingService implements ATAudioStreamingService {
  factory LiveKitAudioStreamingService() {
    _instance ??= LiveKitAudioStreamingService._internal();
    return _instance!;
  }

  LiveKitAudioStreamingService._internal();

  static LiveKitAudioStreamingService? _instance;

  Room? _room;

  final StreamController<List<LiveSessionParticipant>> _participantsController =
      StreamController<List<LiveSessionParticipant>>.broadcast();

  final StreamController<AudioConnectionStatus> _connectionController =
      StreamController<AudioConnectionStatus>.broadcast();

  final StreamController<List<String>> _activeSpeakersController =
      StreamController<List<String>>.broadcast();
  
  final StreamController<List<String>> _speakersWithMicEnabledController =
      StreamController<List<String>>.broadcast();

  CancelListenFunc? _cancelRoomListenerSub;
  LocalAudioTrack? _localAudioTrack;

  @override
  Future<void> connect({
    required String roomUrl,
    required String participantToken,
  }) async {
    try {
      _room = Room();

      _listenToEvents();

      _connectionController.add(AudioConnectionStatus.connecting);

      await _room!.connect(
        roomUrl,
        participantToken,
        connectOptions: const ConnectOptions(
          autoSubscribe: true,
        ),
      );

      await _room!.setSpeakerOn(true);

      _connectionController.add(AudioConnectionStatus.connected);

      await _room!.localParticipant?.setMicrophoneEnabled(false);
    } catch (e, s) {
      log('Error connecting to live kit: $e, stack trace $s');
      _connectionController.add(AudioConnectionStatus.disconnected);
    }
  }


  @override
  Future<void> manuallyDisconnect() async {
    final Room? room = _room;

    if (room == null) {
      return;
    }

    _room = null;

    await _cancelRoomListenerSub?.call();
    _cancelRoomListenerSub = null;

    await _localAudioTrack?.dispose();
    _localAudioTrack = null;

    unawaited(
      room.disconnect().catchError((_) {}),
    );

    room.dispose();

    _connectionController.add(
      AudioConnectionStatus.disconnected,
    );
  }


  @override
  Future<void> setMicEnabled(bool enabled) async {
    await _room?.localParticipant?.setMicrophoneEnabled(enabled);
    _emitParticipantsWithMicEnabled();
  }


  @override
  Stream<List<LiveSessionParticipant>> get participantsStream =>
      _participantsController.stream;

  @override
  Stream<AudioConnectionStatus> get connectionStateStream =>
      _connectionController.stream;

  @override
  Stream<List<String>> get participantsWithMicEnabledStream =>
    _speakersWithMicEnabledController.stream;

  @override
  Stream<List<String>> get activeSpeakersStream =>
      _activeSpeakersController.stream;



  void _listenToEvents() {
    _cancelRoomListenerSub?.call();

    _cancelRoomListenerSub = _room?.events.listen((RoomEvent event) {
      // if(event is ParticipantConnectedEvent){
      //   log('New participant joined.: ${event.participant.identity}, ${event.participant.name}');
      //   _emitParticipants();
      // }
      if (event is ParticipantConnectedEvent ||
          event is ParticipantDisconnectedEvent ||
          event is TrackMutedEvent ||
          event is TrackUnmutedEvent) {
        _emitParticipantsWithMicEnabled();
      }

      if (event is ActiveSpeakersChangedEvent) {
        final List<String> speakers = event.speakers.map(
          (s) => s.identity).toList();
        _activeSpeakersController.add(speakers);

        // _emitParticipants(
        //   audioLevels: <String, double>{
        //     for (final Participant<TrackPublication<Track>> s in event.speakers)
        //       if (s.identity.isNotEmpty)
        //         s.identity: s.audioLevel,
        //   },
        // );
      }
      
      // if(event is DataReceivedEvent){
      //   final foo = event.participant;
      //   final topic = event.topic;

      //   final String raw = utf8.decode(event.data);
      //   final data = jsonDecode(raw);

      //   print("Message: ${data['text']}");
      //   print("From: ${event.participant?.identity}");
      // }

      if (event is RoomDisconnectedEvent) {
        _connectionController.add(AudioConnectionStatus.disconnected);
      }

      if (event is RoomReconnectingEvent) {
        _connectionController.add(AudioConnectionStatus.reconnecting);
      }

      if (event is RoomReconnectedEvent) {
        _connectionController.add(AudioConnectionStatus.connected);
        //_emitParticipants();
      }
    });
  }

  void _emitParticipantsWithMicEnabled() {
    final List<String> ids = <String>[];

    final LocalParticipant? local = _room?.localParticipant;

    if (local != null) {
      final TrackPublication<Track>? audioPub =
          local.audioTrackPublications.firstOrNull;

      if (audioPub != null && !audioPub.muted) {
        ids.add(local.identity);
      }
    }

    for (final RemoteParticipant participant
        in _room?.remoteParticipants.values ?? <RemoteParticipant>[]) {

      final TrackPublication<Track>? audioPub =
          participant.audioTrackPublications.firstOrNull;

      if (audioPub != null && !audioPub.muted) {
        ids.add(participant.identity);
      }
    }

    _speakersWithMicEnabledController.add(ids);
  }


  // void _emitParticipants({Map<String, double>? audioLevels}) {
  //   final Map<String, LiveSessionParticipant> updated =
  //       <String, LiveSessionParticipant>{};

  //   final LocalParticipant? local = _room.localParticipant;
  //   if (local != null) {
  //     updated[local.identity] = _mapParticipant(
  //       local,
  //       isLocal: true,
  //       audioLevel: audioLevels?[local.identity] ?? 0.0,
  //     );
  //   }

  //   for (final RemoteParticipant p in _room.remoteParticipants.values) {
  //     updated[p.identity] = _mapParticipant(
  //       p,
  //       isLocal: false,
  //       audioLevel: audioLevels?[p.identity] ?? 0.0,
  //     );
  //   }

  //   _participantsController.add(updated.values.toList());
  // }


  // LiveSessionParticipant _mapParticipant(
  //   Participant p, {
  //   required bool isLocal,
  //   double audioLevel = 0.0,
  // }) {
  //   final TrackPublication? audioPub = p.audioTrackPublications.firstOrNull;

  //   return LiveSessionParticipant(
  //     isMuted: audioPub?.muted ?? true,
  //     isSpeaking: p.isSpeaking,
  //     isLocal: isLocal,
  //     audioLevel: audioLevel,
  //     name: p.name,
  //     username: p.name,
  //     roomParticipantId: p.identity,
  //   );
  // }
}
