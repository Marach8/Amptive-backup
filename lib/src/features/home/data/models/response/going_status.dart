class GoingStatus {
  GoingStatus({
    required this.isGoing,
    required this.goingCount,
  });

  factory GoingStatus.fromJson(Map<String, dynamic> json) {
    return GoingStatus(
      isGoing: json['is_going'] as bool,
      goingCount: json['going_count'] as int,
    );
  }

  final bool isGoing;
  final int goingCount;
}

enum GoingType {
  event,
  episode,
}
