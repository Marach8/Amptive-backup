import 'package:amptive/src/config/utils/constants.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/livestream/models/livestream_models.dart';

// /// Factory function to convert incoming WebSocket JSON messages into SignalingEvent objects
// SignalingEvent? mapIncomingStreamAction(Map<String, dynamic> json) {
//   final String? type = json['type'] as String?;

//   return switch (type) {
//     SignalingEventType.initial =>
//       InitialStateEvent(InitialState.fromJson(json)),
//     SignalingEventType.streamStarted => StreamStartedEvent(),
//     SignalingEventType.streamEnded => StreamEndedEvent(),
//     SignalingEventType.pong => PongEvent(json['timestamp'] as int? ?? 0),
//     SignalingEventType.participantJoin =>
//       ParticipantJoinEvent(LivestreamParticipant.fromJson(json)),
//     SignalingEventType.participantLeave => ParticipantLeaveEvent(
//         json['identity'] as String? ?? '',
//         json['reason'] as String?,
//       ),
//     SignalingEventType.participantUpdated => ParticipantUpdatedEvent(
//         LivestreamParticipant.fromJson(
//           json['participant'] as Map<String, dynamic>,
//         ),
//       ),
//     SignalingEventType.chat => ChatEvent(ChatMessage.fromJson(json)),
//     SignalingEventType.reaction =>
//       ReactionReceivedEvent(ReactionEvent.fromJson(json)),
//     SignalingEventType.handRaise => HandRaiseEvent(
//         identity: json['user_id'] as String? ?? '',
//         action: json['action'] as String? ?? '',
//       ),
//     SignalingEventType.gift => GiftReceivedEvent(GiftEvent.fromJson(json)),
//     SignalingEventType.viewerCount =>
//       ViewerCountEvent(json['count'] as int? ?? 0),
//     SignalingEventType.participantCount =>
//       ParticipantCountEvent(json['count'] as int? ?? 0),
//     SignalingEventType.userMuted => UserMutedEvent(
//         identity: json['identity'] as String? ?? '',
//         muted: json['muted'] as bool? ?? false,
//       ),
//     SignalingEventType.userBanned => UserBannedEvent(
//         identity: json['identity'] as String? ?? '',
//         reason: json['reason'] as String?,
//       ),
//     SignalingEventType.userKicked => UserKickedEvent(
//         identity: json['identity'] as String? ?? '',
//         reason: json['reason'] as String?,
//       ),
//     SignalingEventType.mediaStateChanged => MediaStateChangedEvent(
//         identity: json['identity'] as String? ?? '',
//         mediaType: json['mediaType'] as String? ?? '',
//         enabled: json['enabled'] as bool? ?? false,
//       ),
//     _ => UnknownEvent(json),
//   };
// }


LiveStreamState1 reduceIncomingStreamAction({
  required Map<String, dynamic> wsJson,
  required LiveStreamState1 stateSnapshot,
}) {
  final InboundEvent? type =
      InboundEvent.fromValue(wsJson['type'] as String?);

  if (type == null) return stateSnapshot;

  return switch (type) {
    InboundEvent.initial => () {
      final InitialStateMapper initial = InitialStateMapper
        .fromJson(wsJson);
      return stateSnapshot.copyWith(
        viewerCount: initial.viewerCount,
        participants: initial.participants,
        handQueue: initial.handQueue,
      );
    }(),


    InboundEvent.streamStarted => stateSnapshot,

    InboundEvent.streamEnded => stateSnapshot.copyWith(
        //connectionErrorMessage: 'Stream ended',
      ),

    InboundEvent.pong => stateSnapshot,

    InboundEvent.participantJoin => () {
        final LivestreamParticipant newParticipant =
            LivestreamParticipant.fromJson(wsJson);
        return stateSnapshot.copyWith(
          participants: <String, LivestreamParticipant>{
            newParticipant.userId: newParticipant,
            ...?stateSnapshot.participants,
          },
        );
      }(),

    InboundEvent.participantLeave => () {
        final String id = wsJson['identity'] ?? '';
        final Map<String, LivestreamParticipant>? participants
          = stateSnapshot.participants;
        participants?.remove(id);
        return stateSnapshot.copyWith(
          participants: participants,
        );
      }(),

    InboundEvent.participantUpdated => () {
      final LivestreamParticipant updatedParticipant =
          LivestreamParticipant.fromJson(wsJson['participant']);
      final Map<String, LivestreamParticipant>? participants 
        = stateSnapshot.participants;
      participants?[updatedParticipant.userId] = updatedParticipant;
      return stateSnapshot.copyWith(
        participants: participants,
      );
    }(),


    InboundEvent.chat => () {
      final ChatMessage newMessage = ChatMessage.fromJson(wsJson);
      if((newMessage.senderId ?? '').isEmpty) return stateSnapshot;
      return stateSnapshot.copyWith(
        messages: <String, ChatMessage>{
          newMessage.senderId ?? '': newMessage,
          ...?stateSnapshot.messages,
        },
        messagesIds: <String>[
          newMessage.senderId ?? '',
          ...?stateSnapshot.messagesIds,
        ]
      );
    }(),


    InboundEvent.reaction => (){
      final Reaction newReaction = Reaction.fromJson(wsJson);
      if((newReaction.id ?? '').isEmpty) return stateSnapshot;
      return stateSnapshot.copyWith(
        reactions: <String, Reaction>{
          newReaction.id!: newReaction,
          ...?stateSnapshot.reactions,
        },
      );
    }(),


    InboundEvent.gift => (){
      final Gift newGift = Gift.fromJson(wsJson);
      if((newGift.giftId ?? '').isEmpty) return stateSnapshot;
      return stateSnapshot.copyWith(
        gifts: <String, Gift>{
          newGift.giftId!: newGift,
          ...?stateSnapshot.gifts,
        },
      );
    }(),


    InboundEvent.handRaise => () {
        final String id = wsJson['user_id'] ?? '';
        final String action = wsJson['action'] ?? '';
        final List<String> queue =
            List<String>.from(stateSnapshot.handQueue ?? <String>[]);
        if (action == 'raise') {
          if (!queue.contains(id)) queue.add(id);
        } else if (action == 'lower') {
          queue.remove(id);
        }
        return stateSnapshot.copyWith(handQueue: queue);
      }(),


    InboundEvent.viewerCount => stateSnapshot.copyWith(
        viewerCount: wsJson['count'] as int? ?? 0,
      ),

    InboundEvent.participantCount => stateSnapshot.copyWith(
        viewerCount: wsJson['count'] as int? ?? 0,
      ),


    InboundEvent.userMuted => () {
        // final String id = json['identity'] as String? ?? '';
        // final bool muted = json['muted'] as bool? ?? false;
        // final List<LiveSessionParticipant>? updated =
        //     state.participants?.map((LiveSessionParticipant p) {
        //   if (p.roomParticipantId == id) {
        //     return p.copyWith(isMuted: muted);
        //   }
        //   return p;
        // }).toList();
        return stateSnapshot.copyWith();
      }(),

    InboundEvent.userBanned => () {
        final String? id = wsJson['identity'];
        if((id ?? '').isEmpty) return stateSnapshot;
        final Map<String, LivestreamParticipant>? participants 
          = stateSnapshot.participants;
        participants?.remove(id);

        return stateSnapshot.copyWith(
          participants: participants,
        );
      }(),

    InboundEvent.userKicked => () {
        final String? id = wsJson['identity'];
        if((id ?? '').isEmpty) return stateSnapshot;
        final Map<String, LivestreamParticipant>? participants 
          = stateSnapshot.participants;
        participants?.remove(id);

        return stateSnapshot.copyWith(
          participants: participants,
        );
      }(),


    InboundEvent.mediaStateChanged => () {
        // final String id = json['identity'] as String? ?? '';
        // final bool enabled = json['enabled'] as bool? ?? false;
        // final List<LiveSessionParticipant>? updated =
        //     state.participants?.map((LiveSessionParticipant p) {
        //   if (p.roomParticipantId == id) {
        //     return p.copyWith(isMuted: !enabled);
        //   }
        //   return p;
        // }).toList();
        return stateSnapshot.copyWith();
      }(),


    InboundEvent.screenShareStarted => stateSnapshot,
    InboundEvent.screenShareEnded => stateSnapshot,

    InboundEvent.pollCreated => stateSnapshot,
    InboundEvent.pollVoted => stateSnapshot,
    InboundEvent.pollEnded => stateSnapshot,

    InboundEvent.error => stateSnapshot,
  };
}
