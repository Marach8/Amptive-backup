import 'dart:async';
import 'dart:developer' show log;
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/services/audio_streaming_service/audio_streaming_service.dart';
import 'package:amptive/src/config/services/audio_streaming_service/live_kit_audio_streaming_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/services/ws_notif_service/ws_channel_service_impl.dart';
import 'package:amptive/src/config/services/ws_notif_service/ws_notif_service.dart';
import 'package:amptive/src/features/go_live/data/models/handle_incoming_stream_action.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/livestream/models/livestream_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveStreamCubit1 extends Cubit<LiveStreamState1> {
  LiveStreamCubit1({
    ATAudioStreamingService? extStreamService,
    WSNotificationService? extWSNotificationService,
    ATLocalStorageService? extLocalStorageService,
    LiveStreamState1? initialState,
  })  : streamingService = extStreamService ?? LiveKitAudioStreamingService(),
        wsNotificationService =
            extWSNotificationService ?? WSChannelNotifServiceImpl(),
        localStorage =
            extLocalStorageService ?? FlutterSecureStorageServiceImpl(),
        super(initialState ?? const LiveStreamState1()) {
    _listenToStreams();

    final Organizers organizers = _retriveOrganizers(state);
    emit(state.copyWith(organizers: organizers));
  }

  final ATAudioStreamingService streamingService;
  final WSNotificationService wsNotificationService;
  final ATLocalStorageService localStorage;

  StreamSubscription<LiveSessionConnectionStatus>? _audioConnectionStateSub;
  StreamSubscription<WSConnectionStatus>? _wsConnectionStateSub;
  StreamSubscription<dynamic>? _wsMessageSub;
  StreamSubscription<List<LiveSessionParticipant>>? _participantsSub;
  StreamSubscription<List<String>>? _activeSpeakersSub;

  void _listenToStreams() {
    // Listen to connection state changes
    _audioConnectionStateSub = streamingService.connectionStateStream
        .listen((LiveSessionConnectionStatus connectionStatus) {
      log('This is the connection status in the cubit: $connectionStatus');
      emit(state.copyWith(audioConnectionStatus: connectionStatus));
    });

    // Listen to ws connection state changes
    _wsConnectionStateSub = wsNotificationService.connectionStream
        .listen((WSConnectionStatus connectionStatus) {
        log('This is the websocket connection status: $connectionStatus');
      if (connectionStatus == WSConnectionStatus.connected) {
        wsNotificationService.sendMessage({
          'type': 'join',
          'streamId': state.liveStreamId,
        });
      }
      emit(state.copyWith(wsConnectionStatus: connectionStatus));
    });

    //Listen to participant changes
    _participantsSub = streamingService.participantsStream
        .listen((List<LiveSessionParticipant> participants) {
      log('This is the number of participants in the cubit: ${participants.length}');
      final Organizers organizers =
          _retriveOrganizers(state.copyWith(participants: participants));

      emit(state.copyWith(
        participants: participants,
        organizers: organizers,
      ));
    });

    // Listen to active speaker changes
    _activeSpeakersSub = streamingService.activeSpeakersStream
        .listen((List<String> activeSpeakerIds) {
      emit(state.copyWith(activeSpeakerIds: activeSpeakerIds));
    });

    // Listen to ws messages
    _wsMessageSub =
        wsNotificationService.messageStream.listen((dynamic message) {
      if (message is Map<String, dynamic>) {
        final SignalingEvent? event = mapIncomingStreamAction(message);
        
        if (event is ChatEvent) {
          state.copyWith(
            messages: <ChatMessage>[event.message, ...?state.messages],
          );
        }
      }
    });
  }

  Organizers _retriveOrganizers(LiveStreamState1 currState) {
    final List<LiveSessionParticipant> participants =
        List<LiveSessionParticipant>.from(
            currState.participants ?? <LiveSessionParticipant>[]);

    List<LiveSessionParticipant?>? cohosts = currState.organizers?.cohosts;
    LiveSessionParticipant? host = currState.organizers?.host;

    if (host == null) {
      for (LiveSessionParticipant participant in participants) {
        if (participant.participantType == LiveParticipantType.host) {
          host = participant;
          break;
        }
      }
    }

    if ((cohosts ?? <LiveSessionParticipant>[]).length < 5) {
      cohosts = participants.where(
        (LiveSessionParticipant participant) =>
            participant.participantType == LiveParticipantType.cohost,
      ).toList();
    }

    return (
      host: host,
      cohosts: cohosts,
    );
  }


  Future<void> connect() async {
    try {
      final String? cachedToken = await localStorage.get(ATStrings.accessToken);
      final String? roomUrl = state.roomUrl;
      final String? participantToken = state.roomEntryToken ?? cachedToken;
      final String? streamId = state.liveStreamId;

      if (roomUrl == null) {
        throw 'Room URL not set';
      }
      if (participantToken == null) {
        throw 'User not authenticated';
      }
      if (streamId == null) {
        throw 'Stream ID is not set';
      }

      final String wsUrl =
          '${ATEndpoints.wsStream}$streamId?token=$participantToken';
      await streamingService.connect(
          roomUrl: roomUrl, participantToken: participantToken);

      await wsNotificationService.connect(wsUrl: wsUrl);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> toggleMicrophone() async {
    await streamingService.toggleMic();
    emit(state.copyWith(
      isMicrophoneEnabled: !state.isMicrophoneEnabled));
  }

  Future<void> disconnect() async {
    await streamingService.disconnect();
  }

  void sendChat(String message){
    log('Sending chat message, checking connection state ${state.wsConnectionStatus}');
    wsNotificationService.sendMessage(<String, dynamic>{
      'type': OutboundMessageType.chat,
      'content': message
    });
  }
    

  void sendReaction(String emoji) =>
  wsNotificationService.sendMessage(<String, dynamic>{
    'type': OutboundMessageType.reaction,
    'content': emoji
  });

  void sendGift(String giftId, int quantity) => 
  wsNotificationService.sendMessage(<String, dynamic>{
    'type': OutboundMessageType.gift,
    'gift_id': giftId,
    'quantity': quantity,
  });

  void raiseHand() => wsNotificationService
    .sendMessage(<String, dynamic>{
      'type': OutboundMessageType.handRaise,
      'action': 'raise',
    });

  void lowerHand() => wsNotificationService
    .sendMessage(<String, dynamic>{
      'type': OutboundMessageType.handRaise,
      'action': 'lower'
    });

  void approveHandRaise(String identity) => 
  wsNotificationService.sendMessage(<String, dynamic>{
    'type': OutboundMessageType.handRaise,
    'action': 'approve',
    'identity': identity,
  });

  void sendPing() => wsNotificationService.sendMessage(<String, dynamic>{
    'type': OutboundMessageType.ping,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  });

  void toggleMedia(String mediaType, bool enabled) => 
  wsNotificationService.sendMessage(<String, dynamic>{
    'type': OutboundMessageType.mediaToggle,
    'mediaType': mediaType,
    'enabled': enabled,
  });

  void toggleScreenShare(bool start) => 
  wsNotificationService.sendMessage(<String, dynamic>{
    'type': OutboundMessageType.screenShare,
    'action': start ? 'start' : 'stop',
  });

  @override
  Future<void> close() {
    // Cancel each individual subscription to prevent memory leaks.
    _audioConnectionStateSub?.cancel();
    _wsConnectionStateSub?.cancel();
    _wsMessageSub?.cancel();
    _participantsSub?.cancel();
    _activeSpeakersSub?.cancel();

    // Dispose of the streaming service resources.
    streamingService.dispose();
    return super.close();
  }
}
