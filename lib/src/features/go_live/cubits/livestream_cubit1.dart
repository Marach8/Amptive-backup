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
import 'package:amptive/src/features/go_live/data/models/sequential_queue.dart';
import 'package:amptive/src/shared/sentinel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/models/deconstruct_inbound_events.dart';

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

    _initializeQueues();
    _listenToStreams();

    // final Organizers organizers = _retriveOrganizers(state);
    // emit(state.copyWith(organizers: organizers));
  }

  late final SequentialQueue<ChatMessage> _chatQueue;
  late final SequentialQueue<Gift> _giftQueue;

  final ATAudioStreamingService streamingService;
  final WSNotificationService wsNotificationService;
  final ATLocalStorageService localStorage;

  StreamSubscription<AudioConnectionStatus>? _audioConnectionStateSub;
  StreamSubscription<WSConnectionStatus>? _wsConnectionStateSub;
  StreamSubscription<dynamic>? _wsMessageSub;
  StreamSubscription<List<LiveSessionParticipant>>? _participantsSub;
  StreamSubscription<List<String>>? _activeSpeakersSub;

  void _initializeQueues() {
    _chatQueue = SequentialQueue<ChatMessage>(
      delay: const Duration(milliseconds: 300),
      maxSize: 200,
      onItem: (ChatMessage chat) {
        emit(state.copyWith(
          messages: <String, ChatMessage>{
            chat.id!: chat,
            ...?state.messages,
          },
          messagesIds: <String>[
            chat.id!,
            ...?state.messagesIds,
          ],
        ));
      },
    );

    // Optional: for gifts (you’ll love this later)
    _giftQueue = SequentialQueue<Gift>(
      delay: const Duration(milliseconds: 200),
      onItem: (Gift gift) {
        emit(state.copyWith(
          latestGift: Sentinel<Gift>.of(gift),
        ));
      },
    );
  }

  void _listenToStreams() {
    // Listen to connection state changes
    _audioConnectionStateSub = streamingService.connectionStateStream
        .listen((AudioConnectionStatus connectionStatus) {
      log('This is the connection status in the cubit: $connectionStatus');
      emit(state.copyWith(audioConnectionStatus: connectionStatus));
    });

    // Listen to ws connection state changes
    _wsConnectionStateSub = wsNotificationService.connectionStream
        .listen((WSConnectionStatus connectionStatus) async{

      if (connectionStatus == WSConnectionStatus.connected) {
        wsNotificationService.sendMessage(<String, dynamic>{
          'type': 'join',
          'streamId': state.liveStreamId,
        });
      }
      emit(state.copyWith(wsConnectionStatus: connectionStatus));
    });

    //Listen to participant changes
    // _participantsSub = streamingService.participantsStream
    //     .listen((List<LiveSessionParticipant> participants) {
    //       for (final i in participants) {
    //         log('This is the participant ${i.name}');
    //       }
    //   log('This is the number of participants in the cubit: ${participants.length}');
    //   final Organizers organizers =
    //       _retriveOrganizers(state.copyWith(participants: participants));

    //   emit(state.copyWith(
    //     participants: participants,
    //     organizers: organizers,
    //   ));
    // });

    // Listen to active speaker changes
    _activeSpeakersSub = streamingService.activeSpeakersStream
        .listen((List<String> activeSpeakerIds) {
      emit(state.copyWith(activeSpeakerIds: activeSpeakerIds));
    });

    // Listen to ws messages
    _wsMessageSub =
        wsNotificationService.messageStream.listen((dynamic message) {
        final String? type = message['type'];

        // ✅ HANDLE CHAT WITH QUEUE
        if (type == 'chat') {
          final ChatMessage chat = ChatMessage.fromJson(message);
          _chatQueue.add(chat);
          return;
        }

        // ✅ HANDLE GIFTS WITH QUEUE (optional but recommended)
        if (type == 'gift') {
          final Gift gift = Gift.fromJson(message);

          final LivestreamParticipant? gifter = state.participants?[gift.senderId ?? ''];
          final Gift updatedGift = gift.copyWith(gifter: gifter);

          _giftQueue.add(updatedGift);
          return;
        }
        
        final LiveStreamState1 newState = reduceIncomingStreamAction(
          wsJson: message,
          stateSnapshot: state,
        );
        emit(newState);
    });
  }

  // Organizers _retriveOrganizers(LiveStreamState1 currState) {
  //   final List<LiveSessionParticipant> participants =
  //       List<LiveSessionParticipant>.from(
  //           currState.participants ?? <LiveSessionParticipant>[]);

  //   List<LiveSessionParticipant?>? cohosts = currState.organizers?.cohosts;
  //   LiveSessionParticipant? host = currState.organizers?.host;

  //   if (host == null) {
  //     for (LiveSessionParticipant participant in participants) {
  //       if (participant.participantType == LiveParticipantType.host) {
  //         host = participant;
  //         break;
  //       }
  //     }
  //   }

  //   if ((cohosts ?? <LiveSessionParticipant>[]).length < 5) {
  //     cohosts = participants.where(
  //       (LiveSessionParticipant participant) =>
  //           participant.participantType == LiveParticipantType.cohost,
  //     ).toList();
  //   }

  //   return (
  //     host: host,
  //     cohosts: cohosts,
  //   );
  // }

  Future<void> connect() async {
    try {
      // Request microphone permission
      final PermissionStatus status = await Permission.microphone.request();
      if (!status.isGranted) {
        throw 'Microphone permission denied';
      }

      final String? cachedToken = await localStorage.get(ATStrings.accessToken);
      final String? roomUrl = state.roomUrl;
      final String? participantToken = state.roomEntryToken;
      final String? streamId = state.liveStreamId;

      if (roomUrl == null) {
        throw 'Room URL not set';
      }
      if (participantToken == null || cachedToken == null) {
        throw 'User not authenticated';
      }
      if (streamId == null) {
        throw 'Stream ID is not set';
      }

      final String wsUrl =
          '${ATEndpoints.wsStream}$streamId?token=$cachedToken';
      await streamingService.connect(
          roomUrl: roomUrl, participantToken: participantToken);

      await wsNotificationService.connect(wsUrl: wsUrl);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> disconnect() async {
    await wsNotificationService.disconnect();
    await streamingService.disconnect();
  }

  void toggleMicrophone(bool isEnabled){
    streamingService.setMicEnabled(isEnabled);
    emit(state.copyWith(isMicEnabled: isEnabled));
  }

  void sendChat(String message) {
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

  void raiseHand() => wsNotificationService.sendMessage(<String, dynamic>{
        'type': OutboundMessageType.handRaise,
        'action': 'raise',
      });

  void lowerHand() => wsNotificationService.sendMessage(<String, dynamic>{
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
    _chatQueue.dispose();
    _giftQueue.dispose();

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
