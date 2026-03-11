class LiveUsersResponseModel {
  LiveUsersResponseModel({
    this.liveUsers,
    this.page,
    this.pageSize,
    this.total,
    this.totalPages,
  });

  factory LiveUsersResponseModel.fromJson(Map<String, dynamic> json) {
    return LiveUsersResponseModel(
      liveUsers: (json['data']?['users'] as List<dynamic>?)
          ?.map((dynamic e) => LiveUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'],
      pageSize: json['page_size'],
      total: json['total'],
      totalPages: json['total_pages'],
    );
  }

  LiveUsersResponseModel copyWith({
    List<LiveUser>? liveUsers,
    int? page,
    int? pageSize,
    int? total,
    int? totalPages,
  }) => LiveUsersResponseModel(
      liveUsers: liveUsers ?? this.liveUsers,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
    );

  bool get hasMore => (page ?? 0) < (totalPages ?? 0);
  final List<LiveUser>? liveUsers;
  final int? page, pageSize, total, totalPages;
}

class LiveUser {
  LiveUser({
    this.userId,
    this.username,
    this.profileImageUrl,
    this.isVerified,
    this.showId,
    this.contentId,
    this.contentType,
    this.viewerCount,
    this.isLive,
  });

  factory LiveUser.fromJson(Map<String, dynamic> json) {
    return LiveUser(
      userId: json['user_id'],
      username: json['username'],
      profileImageUrl: json['profile_image_url'],
      isVerified: json['is_verified'],
      showId: json['show_id'],
      contentId: json['content_id'],
      contentType: json['content_type'],
      viewerCount: json['viewer_count'],
      isLive: json['is_live'],
    );
  }

  final String? userId, username, profileImageUrl,
    showId, contentId, contentType;
  final bool? isVerified, isLive;
  final int? viewerCount;
}
