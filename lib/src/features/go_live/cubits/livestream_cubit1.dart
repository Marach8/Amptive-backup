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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../data/models/deconstruct_inbound_events.dart';

class LiveStreamCubit1 extends Cubit<LiveStreamState1> {
  LiveStreamCubit1({
    required this.myUserId,
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
  late final SequentialQueue<Reaction> _reactionQueue;
  late final SequentialQueue<String> _kickedDetailsQueue;

  final ATAudioStreamingService streamingService;
  final WSNotificationService wsNotificationService;
  final ATLocalStorageService localStorage;
  final String myUserId;

  StreamSubscription<AudioConnectionStatus>? _audioConnectionStateSub;
  StreamSubscription<WSConnectionStatus>? _wsConnectionStateSub;
  StreamSubscription<dynamic>? _wsMessageSub;
  StreamSubscription<List<LiveSessionParticipant>>? _participantsSub;
  StreamSubscription<List<String>>? _activeSpeakersSub;
  StreamSubscription<List<String>>? _speakersWithMicEnabledSub;

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

    _giftQueue = SequentialQueue<Gift>(
      delay: const Duration(seconds: 1),
      maxSize: 200,
      onItem: (Gift gift) {
        emit(state.copyWith(
          gifts: <String, Gift>{
            gift.giftId!: gift,
            ...?state.gifts,
          },
          giftIds: <String>[
            gift.giftId!,
            ...?state.giftIds,
          ],
        ));
      },
    );

    _reactionQueue = SequentialQueue<Reaction>(
      delay: const Duration(milliseconds: 300),
      maxSize: 200,
      onItem: (Reaction reaction) {
        emit(state.copyWith(
          reactions: <Reaction>[
            reaction,
            ...?state.reactions,
          ],
        ));
      },
    );

    _kickedDetailsQueue = SequentialQueue<String>(
      delay: const Duration(milliseconds: 1500),
      maxSize: 100,
      onItem: (String kickDetail) {
        emit(state.copyWith(
          singleKickOutData: kickDetail,
          viewerCount: state.viewerCount - 1,
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
          //log('These are the active speakers $activeSpeakerIds');
      emit(state.copyWith(activeSpeakerIds: activeSpeakerIds));
    });

    // Listen to participants with mic enabled changes
    _speakersWithMicEnabledSub = streamingService.participantsWithMicEnabledStream
        .listen((List<String> participantsWithMicEnabledIds) {
          log('These are the participants with mic enabled $participantsWithMicEnabledIds');
      emit(state.copyWith(unMutedParticipantIds: participantsWithMicEnabledIds));
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

          final LivestreamParticipant? gifter = state.allParticipants?[gift.senderId ?? ''];
          final Gift updatedGift = gift.copyWith(gifter: gifter);

          _giftQueue.add(updatedGift);
          return;
        }

        // ✅ HANDLE REACTIONS WITH QUEUE
        if (type == 'reaction') {
          final Reaction reaction = Reaction.fromJson(message);
          _reactionQueue.add(reaction);
          return;
        }

        // Handle participant kick out
        if (type == 'participant_kicked') {
          final String? kickedUserId = message['user_id'], 
          kickedByUserId = message['kicked_by'];
          final String kickDetail = '$kickedUserId||$kickedByUserId';
          _kickedDetailsQueue.add(kickDetail);
          return;
        }
        
        final LiveStreamState1 newState = reduceIncomingStreamAction(
          wsJson: message,
          stateSnapshot: state,
          myUserId: myUserId,
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

  dynamic removeAParticipant(String participantId){
    final List<String> allParticipantsIds = List<String>
      .from(state.allParticipantsIds ?? <String>[]);
    final List<String> allRaisedHandsIds = List<String>
      .from(state.raisedHandsIds ?? <String>[]);
    final List<String> allUnmutedParticipantIds = List<String>
      .from(state.unMutedParticipantIds ?? <String>[]);
    final List<String> activeSpeakerIds = List<String>
      .from(state.activeSpeakerIds ?? <String>[]);

    allParticipantsIds.remove(participantId);
    allRaisedHandsIds.remove(participantId);
    allUnmutedParticipantIds.remove(participantId);
    activeSpeakerIds.remove(participantId);
    
    emit(state.copyWith(
      allParticipantsIds: allParticipantsIds,
      raisedHandsIds: allRaisedHandsIds,
      unMutedParticipantIds: allUnmutedParticipantIds,
      activeSpeakerIds: activeSpeakerIds,
    ));
  }

  Future<void> disconnect() async {
    Future.wait(<Future<dynamic>>[
      wsNotificationService.disconnect(),
      streamingService.manuallyDisconnect(),
    ]);
  }

  void toggleMicrophone(bool isEnabled) async {
    await streamingService.setMicEnabled(isEnabled);
    emit(state.copyWith(myMicIsEnabled: isEnabled));
  }

  void sendChat(String message) {
    wsNotificationService.sendMessage(<String, dynamic>{
      'type': LiveEventType.chat.value,
      'content': message
    });
  }

  void sendReaction(String emoji) =>
      wsNotificationService.sendMessage(<String, dynamic>{
        'type': LiveEventType.reaction.value,
        'content': emoji
      });

  void sendGift(int quantity) =>
      wsNotificationService.sendMessage(<String, dynamic>{
        'type': LiveEventType.gift.value,
        'gift_id': const Uuid().v4(),
        'gift_type': 'rose',
        'quantity': 20,
      });

  void raiseHand(String userId){
    final bool isMyHandRaised = state.myHandIsRaised == true;
    wsNotificationService.sendMessage(<String, dynamic>{
      'type': LiveEventType.handRaise.value,
      'action': isMyHandRaised ? 'lower' : 'raise',
      'identity': userId,
    });
  }

  void leaveProgram(String userId) => wsNotificationService
    .sendMessage(<String, dynamic>{
        'type': LiveEventType.participantLeave.value,
        'identity': userId,
        'reason': 'user_left',
      });

  void lowerHand(String userId) => wsNotificationService
    .sendMessage(<String, dynamic>{
        'type': LiveEventType.handRaise.value,
        'action': 'lower',
        'identity': userId,
      });

  void approveHandRaise(String idToApprove) =>
      wsNotificationService.sendMessage(<String, dynamic>{
        'type': LiveEventType.handRaise.value,
        'action': 'approve',
        'user_id': idToApprove,
      });

  void sendPing() => wsNotificationService.sendMessage(<String, dynamic>{
        'type': LiveEventType.ping.value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

  void toggleMedia(String mediaType, bool enabled) =>
      wsNotificationService.sendMessage(<String, dynamic>{
        'type': LiveEventType.mediaToggle.value,
        'mediaType': mediaType,
        'enabled': enabled,
      });

  void toggleScreenShare(bool start) =>
      wsNotificationService.sendMessage(<String, dynamic>{
        'type': LiveEventType.screenShare.value,
        'action': start ? 'start' : 'stop',
      });

  
  //Exclusive to hosts and maybe cohosts
  void muteListener(String listenerId) =>
      wsNotificationService.sendMessage(<String, dynamic>{
        'type': 'remove_speaker',
        'user_id': listenerId,
      });
  
  void unMuteListener(String listenerId) =>
      wsNotificationService.sendMessage(<String, dynamic>{
        'type': 'promote_speaker',
        'user_id': listenerId,
      });

  void kickOutListener(String listenerId) =>
      wsNotificationService.sendMessage(<String, dynamic>{
        'type': 'kick_participant',
        'user_id': listenerId,
      });

  void banListener(String listenerId) =>
      wsNotificationService.sendMessage(<String, dynamic>{
        'type': LiveEventType.userBanned.value,
        'user_id': listenerId,
      });

  @override
  Future<void> close() {
    _chatQueue.dispose();
    _giftQueue.dispose();
    _reactionQueue.dispose();
    _kickedDetailsQueue.dispose();

    // Cancel each individual subscription to prevent memory leaks.
    _audioConnectionStateSub?.cancel();
    _wsConnectionStateSub?.cancel();
    _wsMessageSub?.cancel();
    _participantsSub?.cancel();
    _activeSpeakersSub?.cancel();
    _speakersWithMicEnabledSub?.cancel();

    // Dispose of the streaming service resources.
    streamingService.manuallyDisconnect();
    return super.close();
  }
}
