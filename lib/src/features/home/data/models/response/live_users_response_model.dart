class LiveUsersResponseModel {
  LiveUsersResponseModel({
    this.liveUsers,
    this.page,
    this.pageSize,
    this.hasMore,
  });

  factory LiveUsersResponseModel.fromJson(dynamic json) {
    /// CASE 1: API returned a LIST
    if (json is List) {
      return LiveUsersResponseModel(
        liveUsers: json
            .map((dynamic e) => LiveUser.fromJson(e as Map<String, dynamic>))
            .toList(),
        page: null,
        pageSize: null,
        hasMore: null,
      );
    }

    /// CASE 2: API returned a MAP
    if (json is Map<String, dynamic>) {
      return LiveUsersResponseModel(
        liveUsers: (json['items'] as List<dynamic>?)
            ?.map((e) => LiveUser.fromJson(e as Map<String, dynamic>))
            .toList(),
        page: json['page'] as int?,
        pageSize: json['page_size'] as int?,
        hasMore: json['has_more'] as bool?,
      );
    }

    throw Exception('Invalid LiveUsersResponseModel JSON format');
  }

  final List<LiveUser>? liveUsers;
  final int? page, pageSize;
  final bool? hasMore;
}

class LiveUser {
  LiveUser({
    this.userId,
    this.username,
    this.profileImageUrl,
    this.isVerified,
    this.showId,
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
      viewerCount: json['viewer_count'],
      isLive: json['is_live'],
    );
  }

  final String? userId;
  final String? username;
  final String? profileImageUrl;
  final String? showId;
  final bool? isVerified;
  final bool? isLive;
  final int? viewerCount;
}
