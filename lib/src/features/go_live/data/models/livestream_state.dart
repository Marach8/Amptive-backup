import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:equatable/equatable.dart';


class LiveStreamState extends Equatable {
  const LiveStreamState({
    this.connectionStatus = LiveSessionConnectionStatus.initial,
    this.participants = const <LiveSessionParticipant>[],
    this.activeSpeakerIds = const <String>[],
    this.isMicrophoneEnabled = true,
    this.connectionErrorMessage,
  });

  /// The overall status of the livestream connection.
  final LiveSessionConnectionStatus connectionStatus;

  /// A list of all participants currently in the room.
  /// This uses your app-specific `LiveSessionParticipant` model.
  final List<LiveSessionParticipant> participants;

  /// A list of participant IDs for those who are actively speaking.
  final List<String> activeSpeakerIds;

  /// The local user's microphone status.
  final bool isMicrophoneEnabled;

  /// Holds any error message if the status is `LiveSessionConnectionStatus.error`.
  final String? connectionErrorMessage;

  /// Creates a new state object with updated values.
  LiveStreamState copyWith({
    LiveSessionConnectionStatus? connectionStatus,
    List<LiveSessionParticipant>? participants,
    List<String>? activeSpeakerIds,
    bool? isMicrophoneEnabled,
    String? errorMessage,
  }) {
    return LiveStreamState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      participants: participants ?? this.participants,
      activeSpeakerIds: activeSpeakerIds ?? this.activeSpeakerIds,
      isMicrophoneEnabled: isMicrophoneEnabled ?? this.isMicrophoneEnabled,
      connectionErrorMessage: errorMessage ?? connectionErrorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
      connectionStatus,
      participants,
      activeSpeakerIds,
      isMicrophoneEnabled,
      connectionErrorMessage,
    ];
}




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
  initial,
  connecting,
  connected,
  reconnecting,
  disconnected,
}
