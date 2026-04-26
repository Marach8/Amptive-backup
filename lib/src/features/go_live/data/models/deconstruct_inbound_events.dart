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
