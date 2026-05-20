import 'dart:developer' show log;

import 'package:amptive/src/config/utils/constants.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/livestream/models/livestream_models.dart';
import 'package:amptive/src/shared/sentinel.dart';

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
  required String myUserId
}) {
  final LiveEventType? type =
      LiveEventType.fromValue(wsJson['type'] as String?);

  if (type == null) return stateSnapshot;

  return switch (type) {
    LiveEventType.initial => () {
      final InitialStateMapper initial = InitialStateMapper
        .fromJson(wsJson);
      LivestreamParticipant? host;
      List<LivestreamParticipant> cohosts = <LivestreamParticipant>[];

      for(final LivestreamParticipant pt in initial.participants.values) {
        if(pt.role == ParticipantRole.host || pt.isSpeaker == true) {
          host = pt;
        }
        else if(pt.role == ParticipantRole.cohost) {
          cohosts.add(pt);
        }
      }

      return stateSnapshot.copyWith(
        viewerCount: initial.viewerCount,
        participants: initial.participants,
        raisedHandsIds: initial.handQueue,
        organizers: (host: host, cohosts: cohosts)
      );
    }(),


    LiveEventType.streamStarted => stateSnapshot,

    LiveEventType.streamEnded => stateSnapshot.copyWith(
        //connectionErrorMessage: 'Stream ended',
      ),

    LiveEventType.pong => stateSnapshot,

    LiveEventType.participantJoin => () {
      final LivestreamParticipant newParticipant =
          LivestreamParticipant.fromJson(wsJson);
      late LiveStreamState1 newState;

      switch(newParticipant.role) {
        case ParticipantRole.host:
          newState = stateSnapshot.copyWith(
            viewerCount: newParticipant.viewerCount,
            organizers: (host: newParticipant, 
              cohosts: stateSnapshot.organizers?.cohosts),
          );
          break;
        case ParticipantRole.cohost:
          newState = stateSnapshot.copyWith(
            viewerCount: newParticipant.viewerCount,
            organizers: (
              host: stateSnapshot.organizers?.host, 
              cohosts: <LivestreamParticipant?>[
                newParticipant, ...?stateSnapshot.organizers?.cohosts]
            ),
          );
          break;
        default:
          newState = stateSnapshot.copyWith(
            viewerCount: newParticipant.viewerCount,
            participants: <String, LivestreamParticipant>{
              newParticipant.userId: newParticipant,
              ...?stateSnapshot.participants,
            },
          );
          break;
      }
      
      return newState;
    }(),

    LiveEventType.participantLeave => () {
        final String id = wsJson['identity'] ?? '';
        final Map<String, LivestreamParticipant>? participants
          = stateSnapshot.participants;
        participants?.remove(id);
        return stateSnapshot.copyWith(
          participants: participants,
        );
      }(),

    LiveEventType.participantUpdated => () {
      final LivestreamParticipant updatedParticipant =
          LivestreamParticipant.fromJson(wsJson['participant']);
      final Map<String, LivestreamParticipant>? participants 
        = stateSnapshot.participants;
      participants?[updatedParticipant.userId] = updatedParticipant;
      return stateSnapshot.copyWith(
        participants: participants,
      );
    }(),


    LiveEventType.chat => () {
      final ChatMessage newMessage = ChatMessage.fromJson(wsJson);
      if((newMessage.id ?? '').isEmpty) return stateSnapshot;
      return stateSnapshot.copyWith(
        messages: <String, ChatMessage>{
          newMessage.id ?? '': newMessage,
          ...?stateSnapshot.messages,
        },
        messagesIds: <String>[
          newMessage.id ?? '',
          ...?stateSnapshot.messagesIds,
        ]
      );
    }(),


    LiveEventType.reaction => (){
      final Reaction newReaction = Reaction.fromJson(wsJson);
      
      return stateSnapshot.copyWith(
        reactions: <Reaction>[
          newReaction,
          ...?stateSnapshot.reactions,
        ]
      );
    }(),


    LiveEventType.gift => stateSnapshot,


    LiveEventType.handRaise => () {
        bool? myHandIsRaised = stateSnapshot.myHandIsRaised;
        bool? myMicIsEnabled = stateSnapshot.myMicIsEnabled;

        final String raiserId = wsJson['user_id'] ?? '';
        final String action = wsJson['action'] ?? '';
        final List<String> raisedHandsIds = List<String>
          .from(stateSnapshot.raisedHandsIds ?? <String>[]);
        if (action == 'raise') {
          if (!raisedHandsIds.contains(raiserId)) raisedHandsIds.add(raiserId);
          if(raiserId == myUserId) myHandIsRaised = true;
        }
        else if (action == 'lower') {
          raisedHandsIds.remove(raiserId);
          if(raiserId == myUserId) myHandIsRaised = false;
          if(raiserId == myUserId) myMicIsEnabled = false;
        }
        else if (action == 'approve'){
          raisedHandsIds.remove(raiserId);
          if(raiserId == myUserId){
            myHandIsRaised = false;
            myMicIsEnabled = true;
          }
        }
        return stateSnapshot.copyWith(
          raisedHandsIds: raisedHandsIds,
          myHandIsRaised: myHandIsRaised,
          myMicIsEnabled: myMicIsEnabled,
        );
      }(),


    LiveEventType.viewerCount => stateSnapshot.copyWith(
        viewerCount: wsJson['count'] as int? ?? 0,
      ),

    LiveEventType.participantCount => stateSnapshot.copyWith(
        viewerCount: wsJson['count'] as int? ?? 0,
      ),


    LiveEventType.userMuted => () {
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

    LiveEventType.userBanned => () {
        final String? id = wsJson['identity'];
        if((id ?? '').isEmpty) return stateSnapshot;
        final Map<String, LivestreamParticipant>? participants 
          = stateSnapshot.participants;
        participants?.remove(id);

        return stateSnapshot.copyWith(
          participants: participants,
        );
      }(),

    LiveEventType.userKicked => () {
        final String? id = wsJson['identity'];
        if((id ?? '').isEmpty) return stateSnapshot;
        final Map<String, LivestreamParticipant>? participants 
          = stateSnapshot.participants;
        participants?.remove(id);

        return stateSnapshot.copyWith(
          participants: participants,
        );
      }(),


    LiveEventType.mediaStateChanged => () {
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


    LiveEventType.screenShareStarted => stateSnapshot,
    LiveEventType.screenShareEnded => stateSnapshot,

    LiveEventType.pollCreated => stateSnapshot,
    LiveEventType.pollVoted => stateSnapshot,
    LiveEventType.pollEnded => stateSnapshot,

    LiveEventType.error => stateSnapshot,
    LiveEventType.ping => stateSnapshot,
    LiveEventType.mediaToggle => stateSnapshot,
    LiveEventType.screenShare => stateSnapshot,
  };
}
