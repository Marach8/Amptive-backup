import 'package:equatable/equatable.dart';

class FollowingStatus extends Equatable {
  const FollowingStatus({
    this.isFollowing,
    this.followerCount,
  });

  factory FollowingStatus.fromJson(Map<String, dynamic> json) {
    return FollowingStatus(
      isFollowing: json['is_following'],
      followerCount: json['follower_count'],
    );
  }

  final bool? isFollowing;
  final int? followerCount;

  FollowingStatus copyWith({
    bool? isFollowing,
    int? followerCount,
  }) {
    return FollowingStatus(
      isFollowing: isFollowing ?? this.isFollowing,
      followerCount: followerCount ?? this.followerCount,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    isFollowing,
    followerCount,
  ];
}
