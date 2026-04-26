import 'package:amptive/src/livestream/livestream.dart';

class InitialStateMapper {
  InitialStateMapper({
    required this.type,
    required this.participants,
    required this.viewerCount,
    required this.handQueue,
  });

  factory InitialStateMapper.fromJson(Map<String, dynamic> json) {
    final Map<String, LivestreamParticipant> participantsMap
      = <String, LivestreamParticipant>{};

    final List<dynamic> participantsJson = json['participants'] ?? <dynamic>[];

    for (final dynamic item in participantsJson) {
      final LivestreamParticipant participant =
        LivestreamParticipant.fromJson(item);
      participantsMap[participant.userId] = participant;
    }

    return InitialStateMapper(
      type: json['type'] as String? ?? '',
      participants: participantsMap,
      viewerCount: json['viewer_count'] as int? ?? 0,
      handQueue: List<String>.from(json['hand_queue'] ?? <String>[]),
    );
  }

  final String type;
  final Map<String, LivestreamParticipant> participants;
  final int viewerCount;
  final List<String> handQueue;
}




class ChatMessage {
  const ChatMessage({
    this.id,
    this.senderId,
    this.senderName,
    this.message,
    this.timestamp,
    this.avatar,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['timestamp'],
      senderId: json['sender_id'],
      senderName: json['sender_username'],
      message: json['content'],
      timestamp: json['timestamp'],
      avatar: json['avatar'],
    );
  }

  final String? id, senderId, senderName, 
    message, timestamp, avatar;
}

class Reaction {
  const Reaction({
    this.id,
    this.senderId,
    this.emoji,
    this.senderUserName
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'],
      senderId: json['sender_id'],
      emoji: json['content'],
      senderUserName: json['sender_username']
    );
  }

  final String? id, senderId, emoji, senderUserName;
}

class Gift {
  const Gift({
    this.senderId, 
    this.giftId,
    this.giftName,
    this.giftEmoji,
    this.senderUserName,
    this.quantity,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      senderId: json['sender_id'],
      giftId: json['gift_id'],
      giftName: json['gift_name'],
      giftEmoji: json['gift_emoji'],
      senderUserName: json['sender_username'],
      quantity: json['quantity'],
    );
  }

  final String? senderId, giftId,
    giftName, giftEmoji, senderUserName;
  final int? quantity;
}
