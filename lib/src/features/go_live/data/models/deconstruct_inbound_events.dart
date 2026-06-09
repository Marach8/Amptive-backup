import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:uuid/uuid.dart';

class LivestreamParticipant extends User {
  const LivestreamParticipant({
    required super.userId,
    super.username,
    super.profilePicture,
    super.firstName,
    super.lastName,
    super.name,
    super.followersCount,
    super.followingCount,
    super.isVerified,
    required this.role,
    this.newViewerCount,
    this.isSpeaker,
    this.isHost,
    this.isMuted,
  });

  factory LivestreamParticipant.fromJson(Map<String, dynamic> json) {
    return LivestreamParticipant(
      // 👇 reuse parent parsing
      userId: json['user_id'] ?? const Uuid().v4(),
      username: json['username'],
      profilePicture: json['avatar'] ?? json['profile_picture'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      name: json['name'],
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      isVerified: json['is_verified'],

      // 👇 child-specific
      role: ParticipantRole.fromJson(json['role']),
      isSpeaker: json['is_speaker'],
      isHost: json['is_host'],
      isMuted: json['is_muted'],
      newViewerCount: json['viewer_count'],
    );
  }

  final bool? isSpeaker, isHost, isMuted;
  final ParticipantRole role;
  final int? newViewerCount;

  LivestreamParticipant copyWith({
    bool? isSpeaker,
    bool? isMuted,
  }) {
    return LivestreamParticipant(
      userId: userId,
      username: username,
      profilePicture: profilePicture,
      firstName: firstName,
      lastName: lastName,
      name: name,
      followersCount: followersCount,
      followingCount: followingCount,
      isVerified: isVerified,
      role: role,
      isSpeaker: isSpeaker ?? this.isSpeaker,
      isHost: isHost,
      isMuted: isMuted ?? this.isMuted,
      newViewerCount: newViewerCount,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    ...super.props,
    role,
    isSpeaker,
    isHost,
    isMuted,
  ];
}



class ChatMessage {
  const ChatMessage({
    this.id,
    this.senderId,
    this.senderName,
    this.message,
    this.timestamp,
    this.avatar,
    this.role,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['message_id'],
      senderId: json['sender_id'],
      senderName: json['sender_username'],
      message: json['content'],
      timestamp: json['timestamp'],
      avatar: json['sender_avatar'],
      role: ParticipantRole.fromJson(json['role']),
    );
  }

  final String? id, senderId, senderName, 
    message, timestamp, avatar;
  final ParticipantRole? role;
}

class Reaction {
  const Reaction({
    this.senderId,
    this.emoji,
    this.senderUserName
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      senderId: json['sender_id'],
      emoji: json['content'],
      senderUserName: json['sender_username']
    );
  }

  final String? senderId, emoji, senderUserName;
}

class Gift {
  const Gift({
    this.senderId, 
    this.giftId,
    this.giftName,
    this.giftEmoji,
    this.senderUserName,
    this.quantity,
    this.gifter,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      senderId: json['sender_id'],
      giftId: DateTime.now().toIso8601String(),
      //giftId: json['gift_id'],
      giftName: json['gift_name'],
      giftEmoji: json['gift_emoji'],
      senderUserName: json['sender_username'],
      quantity: json['quantity'],
    );
  }

  Gift copyWith({
    String? senderId,
    String? giftId,
    String? giftName,
    String? giftEmoji,
    String? senderUserName,
    int? quantity,
    LivestreamParticipant? gifter,
  }) {
    return Gift(
      senderId: senderId ?? this.senderId,
      giftId: giftId ?? this.giftId,
      giftName: giftName ?? this.giftName,
      giftEmoji: giftEmoji ?? this.giftEmoji,
      senderUserName: senderUserName ?? this.senderUserName,
      quantity: quantity ?? this.quantity,
      gifter: gifter ?? this.gifter,
    );
  }

  final String? senderId, giftId,
    giftName, giftEmoji, senderUserName;
  final int? quantity;
  final LivestreamParticipant? gifter;
}
