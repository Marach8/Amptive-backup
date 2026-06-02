import 'package:amptive/src/config/services/ws_notif_service/ws_channel_service_impl.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/sentinel.dart';
import 'package:equatable/equatable.dart';


class LiveStreamState1 extends Equatable {
  const LiveStreamState1({
    this.audioConnectionStatus = AudioConnectionStatus.initial,
    this.wsConnectionStatus = WSConnectionStatus.initial,
    this.allParticipants,
    this.activeSpeakerIds,
    this.unMutedParticipantIds,
    this.myMicIsEnabled = false,
    this.connectionErrorMessage,
    this.programCoverUrl,
    this.liveStreamId,
    this.roomUrl,
    this.roomEntryToken,
    this.community,
    this.organizersIds,
    this.programTitle,
    this.programDesc,
    this.messages,
    this.reactions,
    this.gifts,
    this.giftIds,
    this.raisedHandsIds,
    this.viewerCount = 0,
    this.messagesIds,
    this.myHandIsRaised,
    this.singleKickOutData,
    this.allParticipantsIds,
    this.myRole,
  });

  final AudioConnectionStatus audioConnectionStatus;
  final WSConnectionStatus wsConnectionStatus;
  final bool myMicIsEnabled;
  final String? connectionErrorMessage,
      programCoverUrl,
      liveStreamId,
      roomUrl,
      roomEntryToken,
      programTitle,
      programDesc, singleKickOutData;
  final Community? community;
  final OrganizersIDs? organizersIds;
  final Map<String, ChatMessage>? messages;
  final Map<String, LivestreamParticipant>? allParticipants;
  final List<Reaction>? reactions;
  final Map<String, Gift>? gifts;
  final List<String>? giftIds, raisedHandsIds,
    messagesIds, activeSpeakerIds, 
    unMutedParticipantIds, allParticipantsIds;
  final ParticipantRole? myRole;
  final int viewerCount;
  final bool? myHandIsRaised;

  /// Creates a new state object with updated values.
  LiveStreamState1 copyWith({
    AudioConnectionStatus? audioConnectionStatus,
    WSConnectionStatus? wsConnectionStatus,
    Map<String, LivestreamParticipant>? allParticipants,
    List<String>? activeSpeakerIds,
    List<String>? unMutedParticipantIds,
    bool? myMicIsEnabled,
    String? errorMessage,
    String? programCoverUrl,
    String? liveStreamId,
    String? roomUrl,
    String? roomEntryToken,
    Community? community,
    OrganizersIDs? organizersIds,
    String? programTitle,
    String? programDesc,
    Map<String, ChatMessage>? messages,
    List<String>? messagesIds,
    List<Reaction>? reactions,
    Map<String, Gift>? gifts,
    List<String>? giftIds,
    List<String>? raisedHandsIds,
    int? viewerCount,
    bool? myHandIsRaised,
    String? singleKickOutData,
    List<String>? allParticipantsIds,
    ParticipantRole? myRole,
  }) {
    return LiveStreamState1(
      audioConnectionStatus: audioConnectionStatus 
        ?? this.audioConnectionStatus,
      wsConnectionStatus: wsConnectionStatus 
        ?? this.wsConnectionStatus,
      allParticipants: allParticipants ?? this.allParticipants,
      activeSpeakerIds: activeSpeakerIds 
        ?? this.activeSpeakerIds,
      myMicIsEnabled: myMicIsEnabled ?? this.myMicIsEnabled,
      connectionErrorMessage: errorMessage 
        ?? connectionErrorMessage,
      programCoverUrl: programCoverUrl ?? this.programCoverUrl,
      liveStreamId: liveStreamId ?? this.liveStreamId,
      roomUrl: roomUrl ?? this.roomUrl,
      roomEntryToken: roomEntryToken ?? this.roomEntryToken,
      community: community ?? this.community,
      organizersIds: organizersIds ?? this.organizersIds,
      programTitle: programTitle ?? this.programTitle,
      programDesc: programDesc ?? this.programDesc,
      messages: messages ?? this.messages,
      reactions: reactions ?? this.reactions,
      gifts: gifts ?? this.gifts,
      giftIds: giftIds ?? this.giftIds,
      raisedHandsIds: raisedHandsIds ?? this.raisedHandsIds,
      viewerCount: viewerCount ?? this.viewerCount,
      messagesIds: messagesIds ?? this.messagesIds,
      myHandIsRaised: myHandIsRaised ?? this.myHandIsRaised,
      unMutedParticipantIds: unMutedParticipantIds 
        ?? this.unMutedParticipantIds,
      singleKickOutData: singleKickOutData 
        ?? this.singleKickOutData,
      allParticipantsIds: allParticipantsIds ?? this.allParticipantsIds,
      myRole: myRole ?? this.myRole,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        audioConnectionStatus,
        wsConnectionStatus,
        allParticipants,
        activeSpeakerIds,
        myMicIsEnabled,
        connectionErrorMessage,
        programCoverUrl,
        liveStreamId,
        roomUrl,
        roomEntryToken,
        community,
        organizersIds,
        programTitle,
        programDesc,
        messages,
        reactions,
        gifts,
        giftIds,
        raisedHandsIds,
        viewerCount,
        messagesIds,
        myHandIsRaised,
        unMutedParticipantIds,
        singleKickOutData,
        allParticipantsIds,
        myRole,
      ];
}

typedef OrganizersIDs = ({
  String? hostId,
  List<String>? cohostsIds,
});

class LiveSessionParticipant extends User {
  const LiveSessionParticipant({
    required this.isMuted,
    required this.isSpeaking,
    required this.isLocal,
    required this.audioLevel,
    this.participantType,
    this.roomParticipantId,
    required super.userId,
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
  final ParticipantRole? participantType;
}

enum AudioConnectionStatus {
  initial,
  connecting,
  connected,
  reconnecting,
  disconnected,
}


// enum LivestreamStatus {
//   initial,
//   connecting,
//   connected,
//   reconnecting,
//   disconnecting,
//   disconnected,
//   failed,
// }
