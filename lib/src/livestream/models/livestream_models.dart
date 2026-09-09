import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';

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


class InitialState {
  const InitialState({
    required this.participants,
    required this.viewerCount,
    required this.handQueue,
  });

  factory InitialState.fromJson(Map<String, dynamic> json) {
    final List<dynamic> participantsJson = json['participants'] as List<dynamic>? ?? <dynamic>[];
    final List<dynamic> handQueueJson = json['hand_queue'] as List<dynamic>? ?? <dynamic>[];
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

  final Reaction reaction;
}

class HandRaiseEvent extends SignalingEvent {
  // "raise" | "lower" | "approve"
  HandRaiseEvent({required this.identity, required this.action});

  final String identity;
  final String action;
}

class GiftReceivedEvent extends SignalingEvent {
  GiftReceivedEvent(this.gift);

  final Gift gift;
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

  const MediaStateChange({
    required this.identity,
    required this.type,
    required this.enabled,
  });
  final String identity;
  final MediaType type;
  final bool enabled;

  @override
  String toString() =>
      'MediaStateChange(identity: $identity, type: $type, enabled: $enabled)';
}
