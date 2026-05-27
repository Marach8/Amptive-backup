import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/shared/global_model_objects.dart';


enum ParticipantRole {
  audience('audience'),
  cohost('cohost'),
  host('host');

  const ParticipantRole(this.value);

  final String value;

  static ParticipantRole fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'host':
        return ParticipantRole.host;
      case 'cohost':
        return ParticipantRole.cohost;
      default:
        return ParticipantRole.audience; // fallback
    }
  }
}


class LiveProgramData {
  const LiveProgramData({
    required this.roomEntryToken,
    required this.roomUrl,
    required this.streamId,
    required this.roomParticipantId,
    required this.role,
    required this.programId,
    required this.coverUrl,
    required this.programTitle,
    required this.programDesc,
    this.community,
  });

  factory LiveProgramData.fromJson(Map<String, dynamic> json) {
    return LiveProgramData(
      roomEntryToken: json['room_entry_token'] ?? '',
      roomUrl: json['room_url'] ?? '',
      streamId: json['stream_id'] ?? '',
      roomParticipantId: json['room_participant_id'] ?? '',
      role: ParticipantRole.fromJson(json['role']),
      programId: json['program_id'] ?? '',
      coverUrl: json['cover_url'] ?? '',
      programTitle: json['program_title'] ?? '',
      programDesc: json['program_desc'] ?? '',
      community: json['community'] == null
          ? null
          : Community.fromJson(
              Map<String, dynamic>.from(json['community']),
            ),
    );
  }

  final String roomEntryToken,
      roomUrl,
      streamId,
      roomParticipantId,
      programId,
      coverUrl,
      programTitle,
      programDesc;

  final ParticipantRole role;
  final Community? community;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'room_entry_token': roomEntryToken,
      'room_url': roomUrl,
      'stream_id': streamId,
      'room_participant_id': roomParticipantId,
      'role': role.value,
      'program_id': programId,
      'cover_url': coverUrl,
      'program_title': programTitle,
      'program_desc': programDesc,
      'community': community?.toJson(),
    };
  }
}
