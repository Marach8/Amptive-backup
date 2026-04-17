import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:equatable/equatable.dart';


class LiveStreamState1 extends Equatable {
  const LiveStreamState1({
    this.connectionStatus = LiveSessionConnectionStatus.initial,
    this.participants,
    this.activeSpeakerIds,
    this.isMicrophoneEnabled = true,
    this.connectionErrorMessage,
    this.programCoverUrl,
    this.liveStreamId,
    this.roomUrl,
    this.roomEntryToken,
    this.community,
    this.organizers,
  });

  final LiveSessionConnectionStatus connectionStatus;
  final List<LiveSessionParticipant>? participants;
  final List<String>? activeSpeakerIds;
  final bool isMicrophoneEnabled;
  final String? connectionErrorMessage, programCoverUrl,
    liveStreamId, roomUrl, roomEntryToken;
  final Community? community;
  final Organizers? organizers;


  /// Creates a new state object with updated values.
  LiveStreamState1 copyWith({
    LiveSessionConnectionStatus? connectionStatus,
    List<LiveSessionParticipant>? participants,
    List<String>? activeSpeakerIds,
    bool? isMicrophoneEnabled,
    String? errorMessage,
    String? programCoverUrl,
    String? liveStreamId,
    String? roomUrl,
    String? roomEntryToken,
    Community? community,
    Organizers? organizers,
  }) {
    return LiveStreamState1(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      participants: participants ?? this.participants,
      activeSpeakerIds: activeSpeakerIds ?? this.activeSpeakerIds,
      isMicrophoneEnabled: isMicrophoneEnabled ?? this.isMicrophoneEnabled,
      connectionErrorMessage: errorMessage ?? connectionErrorMessage,
      programCoverUrl: programCoverUrl ?? this.programCoverUrl,
      liveStreamId: liveStreamId ?? this.liveStreamId,
      roomUrl: roomUrl ?? this.roomUrl,
      roomEntryToken: roomEntryToken ?? this.roomEntryToken,
      community: community ?? this.community,
      organizers: organizers,
    );
  }

  @override
  List<Object?> get props => <Object?>[
      connectionStatus,
      participants,
      activeSpeakerIds,
      isMicrophoneEnabled,
      connectionErrorMessage,
      programCoverUrl,
      liveStreamId,
      roomUrl,
      roomEntryToken,
      community,
      organizers,
    ];
}


typedef Organizers = ({
  LiveSessionParticipant? host,
  List<LiveSessionParticipant?>? cohosts,
});


class LiveSessionParticipant extends User {
  const LiveSessionParticipant({
    required this.isMuted,
    required this.isSpeaking,
    required this.isLocal,
    required this.audioLevel,
    this.participantType,
    this.roomParticipantId,
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
        participantType = json['participant_type'],
        roomParticipantId = json['room_participant_id'],
        super.fromJson();


  /// 🔊 Audio-specific fields
  final bool isMuted, isSpeaking, isLocal;
  final double audioLevel;
  final String? roomParticipantId;
  final LiveParticipantType? participantType;
}

enum LiveSessionConnectionStatus {
  initial,
  connecting,
  connected,
  reconnecting,
  disconnected,
}
