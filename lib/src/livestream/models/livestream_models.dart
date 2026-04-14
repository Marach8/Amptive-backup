enum StreamStatus {
  waiting,
  live,
  ended,
  error,
}

enum PollStatus {
  active,
  ended,
}

enum MediaType {
  audio,
  video,
  screenShare,
}

class LivestreamToken {
  const LivestreamToken({
    required this.token,
    required this.livekitUrl,
    required this.room,
    required this.identity,
  });

  factory LivestreamToken.fromJson(Map<String, dynamic> json) {
    return LivestreamToken(
      token: json['token'] as String,
      livekitUrl: json['livekit_url'] as String,
      room: json['room'] as String,
      identity: json['identity'] as String,
    );
  }

  final String token;
  final String livekitUrl;
  final String room;
  final String identity;
}

class LivestreamParticipant {
  const LivestreamParticipant({
    required this.identity,
    required this.displayName,
    required this.isSpeaker,
    required this.isHost,
    required this.avatar,
    required bool isMuted,
  });

  factory LivestreamParticipant.fromJson(Map<String, dynamic> json) {
    return LivestreamParticipant(
      identity: json['user_id'] as String,
      displayName: json['username'] as String,
      avatar: json['avatar'] as String?,
      isSpeaker: json['is_speaker'] as bool? ?? false,
      isHost: json['is_host'] as bool? ?? false,
      isMuted: json['is_muted'] as bool? ?? false,
    );
  }

  final String identity;
  final String displayName;
  final bool isSpeaker;
  final bool isHost;
  final String? avatar;
  final bool isMuted = false;

  LivestreamParticipant copyWith({bool? isSpeaker, bool? isMuted}) {
    return LivestreamParticipant(
      identity: identity,
      displayName: displayName,
      isSpeaker: isSpeaker ?? this.isSpeaker,
      isHost: isHost,
      avatar: null,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}

class InitialState {
  const InitialState({
    required this.participants,
    required this.viewerCount,
    required this.handQueue,
  });

  factory InitialState.fromJson(Map<String, dynamic> json) {
    final participantsJson = json['participants'] as List<dynamic>? ?? [];
    final handQueueJson = json['hand_queue'] as List<dynamic>? ?? [];
    return InitialState(
      participants: participantsJson
          .map((p) => LivestreamParticipant.fromJson(p as Map<String, dynamic>))
          .toList(),
      viewerCount: json['viewer_count'] as int? ?? 0,
      handQueue: handQueueJson.map((e) => e as String).toList(),
    );
  }

  final List<LivestreamParticipant> participants;
  final int viewerCount;
  final List<String> handQueue;
}

class ChatMessage {
  const ChatMessage({
    required this.identity,
    required this.displayName,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      identity: json['sender_id'] as String,
      displayName: json['sender_username'] as String? ?? "",
      message: json['content'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  final String identity;
  final String displayName;
  final String message;
  final DateTime timestamp;
}

class ReactionEvent {
  const ReactionEvent(
      {required this.identity, required this.emoji, required this.displayName});

  factory ReactionEvent.fromJson(Map<String, dynamic> json) {
    return ReactionEvent(
        identity: json['sender_id'] as String,
        emoji: json['content'] as String,
        displayName: json['sender_username'] as String);
  }

  final String identity;
  final String emoji;
  final String displayName;
}

class GiftEvent {
  const GiftEvent({
    required this.identity,
    required this.giftId,
    required this.giftName,
    required this.giftEmoji,
    required this.displayName,
    required this.quantity,
  });

  factory GiftEvent.fromJson(Map<String, dynamic> json) {
    return GiftEvent(
      identity: json['sender_id'] as String,
      giftId: json['gift_id'] as String? ?? '',
      giftName: json['gift_name'] as String? ?? 'Gift',
      giftEmoji: json['gift_emoji'] as String? ?? '🎁',
      displayName: json['sender_username'] as String? ?? 'Someone',
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  final String identity;
  final String giftId;
  final String giftName;
  final String giftEmoji;
  final String displayName;
  final int quantity;
}

// ── Signaling events coming in from the WebSocket ──────────────────────────

sealed class SignalingEvent {}

class InitialStateEvent extends SignalingEvent {
  InitialStateEvent(this.state);

  final InitialState state;
}

class StreamStartedEvent extends SignalingEvent {}

class StreamEndedEvent extends SignalingEvent {}

class ChatEvent extends SignalingEvent {
  ChatEvent(this.message);

  final ChatMessage message;
}

class ReactionReceivedEvent extends SignalingEvent {
  ReactionReceivedEvent(this.reaction);

  final ReactionEvent reaction;
}

class HandRaiseEvent extends SignalingEvent {
  // "raise" | "lower" | "approve"
  HandRaiseEvent({required this.identity, required this.action});

  final String identity;
  final String action;
}

class GiftReceivedEvent extends SignalingEvent {
  GiftReceivedEvent(this.gift);

  final GiftEvent gift;
}

class ParticipantUpdatedEvent extends SignalingEvent {
  ParticipantUpdatedEvent(this.participant);

  final LivestreamParticipant participant;
}

class ViewerCountEvent extends SignalingEvent {
  ViewerCountEvent(this.count);

  final int count;
}

class UnknownEvent extends SignalingEvent {
  UnknownEvent(this.raw);

  final Map<String, dynamic> raw;
}

class PongEvent implements SignalingEvent {
  const PongEvent(this.timestamp);

  final int timestamp;
}

class ParticipantJoinEvent implements SignalingEvent {
  const ParticipantJoinEvent(this.participant);

  final LivestreamParticipant participant;
}

class ParticipantLeaveEvent implements SignalingEvent {
  const ParticipantLeaveEvent(this.identity, this.reason);

  final String identity;
  final String? reason;
}

class ParticipantCountEvent implements SignalingEvent {
  const ParticipantCountEvent(this.count);

  final int count;
}

class ErrorEvent implements SignalingEvent {
  const ErrorEvent({
    required this.code,
    required this.message,
    this.details,
  });

  final String code;
  final String message;
  final String? details;
}

class UserMutedEvent implements SignalingEvent {
  const UserMutedEvent({
    required this.identity,
    required this.muted,
  });

  final String identity;
  final bool muted;
}

class UserBannedEvent implements SignalingEvent {
  const UserBannedEvent({
    required this.identity,
    this.reason,
  });

  final String identity;
  final String? reason;
}

class UserKickedEvent implements SignalingEvent {
  const UserKickedEvent({
    required this.identity,
    this.reason,
  });

  final String identity;
  final String? reason;
}

class MediaStateChangedEvent implements SignalingEvent {
  const MediaStateChangedEvent({
    required this.identity,
    required this.mediaType,
    required this.enabled,
  });

  final String identity;
  final String mediaType;
  final bool enabled;
}

/// Represents a change in media state (audio/video enabled/disabled)
class MediaStateChange {
  final String identity;
  final MediaType type;
  final bool enabled;

  const MediaStateChange({
    required this.identity,
    required this.type,
    required this.enabled,
  });

  @override
  String toString() =>
      'MediaStateChange(identity: $identity, type: $type, enabled: $enabled)';
}
