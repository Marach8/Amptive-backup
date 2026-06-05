import 'package:amptive/src/config/utils/constants.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';

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
      String? hostId;
      List<String> cohostsIds = <String>[];

      final Map<String, LivestreamParticipant> allParticipantsMap
        = <String, LivestreamParticipant>{};
      List<String> allParticipantsIds = <String>[];

      final List<dynamic> participantsJson = 
        wsJson['participants'] ?? <dynamic>[];
      final int viewerCount = wsJson['viewer_count'] ?? 0;
      final List<String> handQueue = List<String>
        .from(wsJson['hand_queue'] ?? <String>[]);

      for (final dynamic ptJson in participantsJson) {
        final LivestreamParticipant participant = 
          LivestreamParticipant.fromJson(ptJson);
        if(participant.role == ParticipantRole.host) {
          hostId = participant.userId;
        }
        else if(participant.role == ParticipantRole.cohost) {
          cohostsIds.add(participant.userId);
        }

        allParticipantsMap[participant.userId] = participant;
        allParticipantsIds.add(participant.userId);
      }

      return stateSnapshot.copyWith(
        viewerCount: viewerCount,
        allParticipants: allParticipantsMap,
        allParticipantsIds: allParticipantsIds,
        raisedHandsIds: handQueue,
        organizersIds: (hostId: hostId, cohostsIds: cohostsIds),
      );
    }(),


    LiveEventType.streamStarted => stateSnapshot,

    LiveEventType.streamEnded => stateSnapshot.copyWith(
        liveStreamEnded: true,
      ),

    LiveEventType.pong => stateSnapshot,

    LiveEventType.participantJoin => () {
      final LivestreamParticipant newParticipant =
          LivestreamParticipant.fromJson(wsJson);

      OrganizersIDs? organizersIds = stateSnapshot.organizersIds;
      List<String> allParticipantsIds = stateSnapshot
        .allParticipantsIds ?? <String>[];

      final bool isExistingParticipant = 
        allParticipantsIds.contains(newParticipant.userId);
      final bool isExistingCohost = organizersIds
        ?.cohostsIds?.contains(newParticipant.userId) ?? false;

      switch(newParticipant.role) {
        case ParticipantRole.host:
            organizersIds = (
              hostId: newParticipant.userId, 
              cohostsIds: organizersIds?.cohostsIds,
            );
          break;
        case ParticipantRole.cohost:
            organizersIds = (
              hostId: organizersIds?.hostId,
              cohostsIds: <String>[
                ...?organizersIds?.cohostsIds,
                if(!isExistingCohost) newParticipant.userId
              ],
            );
          break;
        default:
          break;
      }
      
      return stateSnapshot.copyWith(
        viewerCount: newParticipant.newViewerCount,
        allParticipants: <String, LivestreamParticipant>{
          ...?stateSnapshot.allParticipants,
          newParticipant.userId: newParticipant,
        },
        allParticipantsIds: <String>[
          if(!isExistingParticipant) newParticipant.userId,
          ...?stateSnapshot.allParticipantsIds,
        ],
        organizersIds: organizersIds,
      );
    }(),

    LiveEventType.participantLeave => () {
        final String leaverId = wsJson['identity'] ?? '';
        final Map<String, LivestreamParticipant>? allParticipants
          = stateSnapshot.allParticipants;
        final List<String>? allParticipantsIds = 
          stateSnapshot.allParticipantsIds;
        OrganizersIDs? organizersIds = stateSnapshot.organizersIds;
        List<String>? raisedHandsIds = stateSnapshot.raisedHandsIds;
        List<String>? unMutedParticipantIds = stateSnapshot.unMutedParticipantIds;
        List<String>? activeSpeakerIds = stateSnapshot.activeSpeakerIds;

        organizersIds = (
          hostId: organizersIds?.hostId == leaverId
              ? null
              : organizersIds?.hostId,
          cohostsIds: <String>[
            ...?organizersIds?.cohostsIds,
          ]..remove(leaverId),
        );

        allParticipants?.remove(leaverId);
        allParticipantsIds?.remove(leaverId);
        raisedHandsIds?.remove(leaverId);
        unMutedParticipantIds?.remove(leaverId);
        activeSpeakerIds?.remove(leaverId);

        return stateSnapshot.copyWith(
          allParticipants: allParticipants,
          allParticipantsIds: allParticipantsIds,
          organizersIds: organizersIds,
          raisedHandsIds: raisedHandsIds,
          activeSpeakerIds: activeSpeakerIds,
          unMutedParticipantIds: unMutedParticipantIds,
        );
      }(),

    LiveEventType.participantUpdated => () {
      final LivestreamParticipant updatedParticipant =
          LivestreamParticipant.fromJson(wsJson['participant']);
      final Map<String, LivestreamParticipant>? participants 
        = stateSnapshot.allParticipants;
      participants?[updatedParticipant.userId] = updatedParticipant;
      return stateSnapshot.copyWith(
        allParticipants: participants,
        allParticipantsIds: <String>[
          updatedParticipant.userId,
          ...?stateSnapshot.allParticipantsIds,
        ]
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
        List<String> unMutedParticipantIds = List<String>
          .from(stateSnapshot.unMutedParticipantIds ?? <String>[]);

        if (action == 'raise') {
          if (!raisedHandsIds.contains(raiserId)) raisedHandsIds.add(raiserId);
          if(raiserId == myUserId) myHandIsRaised = true;
        }
        else if (action == 'lower') {
          raisedHandsIds.remove(raiserId);
          if(raiserId == myUserId){
            myHandIsRaised = false;
            myMicIsEnabled = false;
          }
        }
        else if (action == 'approve'){
          raisedHandsIds.remove(raiserId);
          if(raiserId == myUserId){
            myHandIsRaised = false;
            myMicIsEnabled = true;
          }
          unMutedParticipantIds.add(raiserId);
        }
        return stateSnapshot.copyWith(
          raisedHandsIds: raisedHandsIds,
          myHandIsRaised: myHandIsRaised,
          myMicIsEnabled: myMicIsEnabled,
          unMutedParticipantIds: unMutedParticipantIds,
        );
      }(),


    LiveEventType.viewerCount => stateSnapshot.copyWith(
        viewerCount: wsJson['count'] as int? ?? 0,
      ),

    LiveEventType.participantCount => stateSnapshot.copyWith(
        viewerCount: wsJson['count'] as int? ?? 0,
      ),


    LiveEventType.userMuted => () {
        bool? myMicIsEnabled = stateSnapshot.myMicIsEnabled;
        final String mutedUserId = wsJson['user_id'] ?? '';
        //final String promoterId = wsJson['promoter_id'] ?? '';

        if(mutedUserId == myUserId) myMicIsEnabled = false;

        final List<String> unMutedParticipantIds = List<String>
          .from(stateSnapshot.unMutedParticipantIds ?? <String>[]);
          unMutedParticipantIds.remove(mutedUserId);

        return stateSnapshot.copyWith(
          myMicIsEnabled: myMicIsEnabled,
          unMutedParticipantIds: unMutedParticipantIds,
        );
      }(),

      LiveEventType.userUnmuted => () {
        bool? myMicIsEnabled = stateSnapshot.myMicIsEnabled;
        final String unMutedUserId = wsJson['user_id'] ?? '';
        //final String promoterId = wsJson['promoter_id'] ?? '';
        if(unMutedUserId == myUserId) myMicIsEnabled = true;

        return stateSnapshot.copyWith(
          myMicIsEnabled: myMicIsEnabled,
          unMutedParticipantIds: <String>[
            unMutedUserId,
            ...?stateSnapshot.unMutedParticipantIds
          ],
        );
      }(),

    LiveEventType.userBanned => () {
      final String? id = wsJson['identity'];
      if((id ?? '').isEmpty) return stateSnapshot;
      final Map<String, LivestreamParticipant>? participants 
        = stateSnapshot.allParticipants;
      final List<String>? allParticipantsIds 
        = stateSnapshot.allParticipantsIds;
      
      allParticipantsIds?.remove(id);
      participants?.remove(id);


      return stateSnapshot.copyWith(
        allParticipants: participants,
        allParticipantsIds: allParticipantsIds,
      );
    }(),

    LiveEventType.participantKicked => stateSnapshot,

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
