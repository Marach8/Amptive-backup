class HomeFeedResponseModel {
  HomeFeedResponseModel({
    this.homeFeedItems,
    this.page,
    this.pageSize,
    this.hasMore,
  });

  factory HomeFeedResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeFeedResponseModel(
      homeFeedItems: (json['items'] as List<dynamic>?)
          ?.map((dynamic e) => HomeFeedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'],
      pageSize: json['page_size'],
      hasMore: json['has_more'],
    );
  }

  final List<HomeFeedItem>? homeFeedItems;
  final int? page, pageSize;
  final bool? hasMore;
}

class HomeFeedItem {
  HomeFeedItem({
    this.id,
    this.title,
    this.programCategory,
    this.programStatus,
    this.hostId,
    this.hostProfileImageUrl,
    this.hostName,
    this.programType,
    this.price,
    this.viewerCount,
    this.goingCount,
    this.coverUrl,
    this.startedAt,
    this.scheduledFor,
    this.score,
    this.requesterFollowsHost,
    this.requesterIsGoing,
    this.livestreamId,
    this.coHostCount,
    this.avatarUrls,
    this.showId,
    this.showTitle,
    this.showCoverUrl,
    this.showCategory,
    this.episodeNumber,
    this.thumbnailUrl,
  });

  factory HomeFeedItem.fromJson(Map<String, dynamic> json) {
    return HomeFeedItem(
      id: json['id'],
      title: json['title'],
      programCategory: ProgramCategory.fromJson(json['content_type']),
      programStatus: ProgramStatus.fromJson(json['status']),
      hostId: json['host_id'],
      hostProfileImageUrl: json['host_profile_image_url'],
      hostName: json['host_name'],
      programType: ProgramType.fromJson(json['show_type']),
      price: json['price'],
      viewerCount: json['viewer_count'],
      goingCount: json['going_count'],
      coverUrl: json['cover_url'],
      startedAt: json['started_at'],
      scheduledFor: json['scheduled_for'],
      score: json['score']?.toDouble(),
      requesterFollowsHost: json['requester_follows_host'],
      requesterIsGoing: json['requester_is_going'],
      livestreamId: json['livestream_id'],
      coHostCount: (json['co_hosts'] as List<dynamic>?)?.length ?? 0,
      avatarUrls: (json['avatar_urls'] as List<dynamic>?)
          ?.map((dynamic e) => e as String)
          .toList(),
      showId: json['show_id'],
      showTitle: json['show_title'],
      showCoverUrl: json['show_cover_url'],
      showCategory: json['show_category'],
      episodeNumber: json['episode_number'],
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }

  HomeFeedItem copyWith({
    String? id,
    String? title,
    ProgramCategory? programCategory,
    ProgramStatus? programStatus,
    String? hostId,
    String? hostProfileImageUrl,
    String? hostName,
    ProgramType? programType,
    double? price,
    int? viewerCount,
    int? goingCount,
    String? coverUrl,
    String? startedAt,
    String? scheduledFor,
    double? score,
    bool? requesterFollowsHost,
    bool? requesterIsGoing,
    String? livestreamId,
    int? coHostCount,
    List<String>? avatarUrls,
    String? showId,
    String? showTitle,
    String? showCoverUrl,
    String? showCategory,
    int? episodeNumber,
    String? thumbnailUrl,
  }) {
    return HomeFeedItem(
      id: id ?? this.id,
      title: title ?? this.title,
      programCategory: programCategory ?? this.programCategory,
      programStatus: programStatus ?? this.programStatus,
      hostId: hostId ?? this.hostId,
      hostProfileImageUrl:
          hostProfileImageUrl ?? this.hostProfileImageUrl,
      hostName: hostName ?? this.hostName,
      programType: programType ?? this.programType,
      price: price ?? this.price,
      viewerCount: viewerCount ?? this.viewerCount,
      goingCount: goingCount ?? this.goingCount,
      coverUrl: coverUrl ?? this.coverUrl,
      startedAt: startedAt ?? this.startedAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      score: score ?? this.score,
      requesterFollowsHost:
          requesterFollowsHost ?? this.requesterFollowsHost,
      requesterIsGoing:
          requesterIsGoing ?? this.requesterIsGoing,
      livestreamId: livestreamId ?? this.livestreamId,
      coHostCount: coHostCount ?? this.coHostCount,
      avatarUrls: avatarUrls ?? this.avatarUrls,
      showId: showId ?? this.showId,
      showTitle: showTitle ?? this.showTitle,
      showCoverUrl: showCoverUrl ?? this.showCoverUrl,
      showCategory: showCategory ?? this.showCategory,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  final String? id,
      title,
      hostId,
      hostProfileImageUrl,
      hostName,
      coverUrl,
      startedAt,
      scheduledFor,
      livestreamId,
      showId,
      showTitle,
      showCoverUrl,
      showCategory,
      thumbnailUrl;

  final ProgramType? programType;
  final ProgramCategory? programCategory;
  final ProgramStatus? programStatus;
  final double? price, score;
  final int? viewerCount, goingCount, coHostCount, episodeNumber;
  final bool? requesterFollowsHost, requesterIsGoing;
  final List<String>? avatarUrls;
}

enum ProgramType {
  free('free'),
  paid('paid');

  const ProgramType(this.value);
  final String value;

  static ProgramType fromJson(String? json) =>
      ProgramType.values.firstWhere(
        (ProgramType e) => e.value == json,
        orElse: () => ProgramType.free
      );
}

enum ProgramCategory {
  episode('episode'),
  standalone('standalone');

  const ProgramCategory(this.value);
  final String value;

  static ProgramCategory fromJson(String? json) =>
      ProgramCategory.values.firstWhere(
        (ProgramCategory e) => e.value == json,
        orElse: () => ProgramCategory.standalone,
      );
}

enum ProgramStatus {
  draft('DRAFT'),
  scheduled('SCHEDULED'),
  live('LIVE'),
  ended('ENDED'),
  cancelled('CANCELLED');

  const ProgramStatus(this.value);
  final String value;

  static ProgramStatus fromJson(String? json) => 
    ProgramStatus.values.firstWhere(
        (ProgramStatus e) => e.value == json,
        orElse: () => ProgramStatus.draft,
      );
}
