import 'package:amptive/src/shared/global_model_objects.dart';

class LiveSessionParticipant extends User {
  const LiveSessionParticipant({
    required this.isMuted,
    required this.isSpeaking,
    required this.isLocal,
    required this.audioLevel,
    super.userId,
    super.username,
    super.profilePicture,
    super.followersCount,
    super.followingCount,
    super.firstName,
    super.lastName,
    super.name,
    super.isVerified,
  });

  LiveSessionParticipant.fromJson(super.json)
      : isMuted = json['is_muted'],
        isSpeaking = json['is_speaking'],
        isLocal = json['is_local'],
        audioLevel = json['audio_level'],
        super.fromJson();


  /// 🔊 Audio-specific fields
  final bool isMuted, isSpeaking, isLocal;
  final double audioLevel;
}

enum LiveSessionConnectionStatus {
  connecting,
  connected,
  reconnecting,
  disconnected,
}
