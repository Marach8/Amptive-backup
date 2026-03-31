enum StreamStatus { waiting, live, ended }

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
  });

  factory LivestreamParticipant.fromJson(Map<String, dynamic> json) {
    return LivestreamParticipant(
      identity: json['identity'] as String,
      displayName: json['display_name'] as String? ?? json['identity'] as String,
      isSpeaker: json['is_speaker'] as bool? ?? false,
      isHost: json['is_host'] as bool? ?? false,
    );
  }
  final String identity;
  final String displayName;
  final bool isSpeaker;
  final bool isHost;

  LivestreamParticipant copyWith({bool? isSpeaker}) {
    return LivestreamParticipant(
      identity: identity,
      displayName: displayName,
      isSpeaker: isSpeaker ?? this.isSpeaker,
      isHost: isHost,
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
      identity: json['identity'] as String,
      displayName: json['display_name'] as String? ?? json['identity'] as String,
      message: json['message'] as String,
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

  const ReactionEvent({required this.identity, required this.emoji});

  factory ReactionEvent.fromJson(Map<String, dynamic> json) {
    return ReactionEvent(
      identity: json['identity'] as String,
      emoji: json['emoji'] as String,
    );
  }
  final String identity;
  final String emoji;
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

class HandRaiseEvent extends SignalingEvent { // "raise" | "lower" | "approve"
  HandRaiseEvent({required this.identity, required this.action});
  final String identity;
  final String action;
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