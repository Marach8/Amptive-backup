class FollowResponseModel {
  const FollowResponseModel({
    required this.isFollowing,
    required this.followerCount,
  });

  factory FollowResponseModel.fromJson(Map<String, dynamic> json) {
    return FollowResponseModel(
      isFollowing: json['is_following'] as bool? ?? false,
      followerCount: json['follower_count'] as int? ?? 0,
    );
  }

  final bool isFollowing;
  final int followerCount;
}
