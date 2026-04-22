import 'package:amptive/src/config/utils/constants.dart';
import 'package:amptive/src/livestream/models/livestream_models.dart';

/// Factory function to convert incoming WebSocket JSON messages into SignalingEvent objects
SignalingEvent? mapIncomingStreamAction(Map<String, dynamic> json) {
  final String? type = json['type'] as String?;

  return switch (type) {
    SignalingEventType.initial =>
      InitialStateEvent(InitialState.fromJson(json)),
    SignalingEventType.streamStarted => StreamStartedEvent(),
    SignalingEventType.streamEnded => StreamEndedEvent(),
    SignalingEventType.pong => PongEvent(json['timestamp'] as int? ?? 0),
    SignalingEventType.participantJoin =>
      ParticipantJoinEvent(LivestreamParticipant.fromJson(json)),
    SignalingEventType.participantLeave => ParticipantLeaveEvent(
        json['identity'] as String? ?? '',
        json['reason'] as String?,
      ),
    SignalingEventType.participantUpdated => ParticipantUpdatedEvent(
        LivestreamParticipant.fromJson(
          json['participant'] as Map<String, dynamic>,
        ),
      ),
    SignalingEventType.chat => ChatEvent(ChatMessage.fromJson(json)),
    SignalingEventType.reaction =>
      ReactionReceivedEvent(ReactionEvent.fromJson(json)),
    SignalingEventType.handRaise => HandRaiseEvent(
        identity: json['user_id'] as String? ?? '',
        action: json['action'] as String? ?? '',
      ),
    SignalingEventType.gift => GiftReceivedEvent(GiftEvent.fromJson(json)),
    SignalingEventType.viewerCount =>
      ViewerCountEvent(json['count'] as int? ?? 0),
    SignalingEventType.participantCount =>
      ParticipantCountEvent(json['count'] as int? ?? 0),
    SignalingEventType.userMuted => UserMutedEvent(
        identity: json['identity'] as String? ?? '',
        muted: json['muted'] as bool? ?? false,
      ),
    SignalingEventType.userBanned => UserBannedEvent(
        identity: json['identity'] as String? ?? '',
        reason: json['reason'] as String?,
      ),
    SignalingEventType.userKicked => UserKickedEvent(
        identity: json['identity'] as String? ?? '',
        reason: json['reason'] as String?,
      ),
    SignalingEventType.mediaStateChanged => MediaStateChangedEvent(
        identity: json['identity'] as String? ?? '',
        mediaType: json['mediaType'] as String? ?? '',
        enabled: json['enabled'] as bool? ?? false,
      ),
    _ => UnknownEvent(json),
  };
}
