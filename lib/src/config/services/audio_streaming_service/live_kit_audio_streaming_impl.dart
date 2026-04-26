import 'dart:async';
import 'dart:developer' show log;
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
  LocalAudioTrack? _localAudioTrack;

  @override
  Future<void> connect({
    required String roomUrl,
    required String participantToken,
  }) async {
    try {
      _listenToEvents();

      _connectionController.add(LiveSessionConnectionStatus.connecting);

      await _room.connect(
        roomUrl,
        participantToken,
        connectOptions: const ConnectOptions(
          autoSubscribe: true, // important
        ),
      );

      await _room.setSpeakerOn(true);

      _connectionController.add(LiveSessionConnectionStatus.connected);

      await _room.localParticipant?.setMicrophoneEnabled(false);

      //_emitParticipants();
    } catch (e, s) {
      log('Error connecting to live kit: $e, stack trace $s');
      _connectionController.add(LiveSessionConnectionStatus.disconnected);
    }
  }


  @override
  Future<void> disconnect() async {
    await _room.disconnect();
    _connectionController.add(LiveSessionConnectionStatus.disconnected);
  }


  @override
  Future<void> setMicEnabled(bool enabled) async {
    await _room.localParticipant?.setMicrophoneEnabled(enabled);
    // _emitParticipants();
  }


  @override
  Stream<List<LiveSessionParticipant>> get participantsStream =>
      _participantsController.stream;

  @override
  Stream<LiveSessionConnectionStatus> get connectionStateStream =>
      _connectionController.stream;

  @override
  Stream<List<String>> get activeSpeakersStream =>
      _activeSpeakersController.stream;



  void _listenToEvents() {
    _roomSub?.call();

    _roomSub = _room.events.listen((RoomEvent event) {
      // if(event is ParticipantConnectedEvent){
      //   log('New participant joined.: ${event.participant.identity}, ${event.participant.name}');
      //   _emitParticipants();
      // }
      if (event is ParticipantConnectedEvent || event is ParticipantDisconnectedEvent ||
          event is TrackMutedEvent ||
          event is TrackUnmutedEvent) {
        //_emitParticipants();
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
        _connectionController.add(LiveSessionConnectionStatus.disconnected);
      }

      if (event is RoomReconnectingEvent) {
        _connectionController.add(LiveSessionConnectionStatus.reconnecting);
      }

      if (event is RoomReconnectedEvent) {
        _connectionController.add(LiveSessionConnectionStatus.connected);
        //_emitParticipants();
      }
    });
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


  @override
  Future<void> dispose() async {
    await _localAudioTrack?.dispose();
    await _roomSub?.call();
    await _participantsController.close();
    await _connectionController.close();
    await _activeSpeakersController.close();
    await _room.dispose();
  }
}
