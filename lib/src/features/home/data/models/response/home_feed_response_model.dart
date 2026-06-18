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
    this.contentTypeEnum,
    this.statusEnum,
    this.hostId,
    this.hostProfileImageUrl,
    this.hostName,
    this.showType,
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
      contentTypeEnum: ProgramType.fromJson(json['content_type']),
      statusEnum: ProgramStatus.fromJson(json['status']),
      hostId: json['host_id'],
      hostProfileImageUrl: json['host_profile_image_url'],
      hostName: json['host_name'],
      showType: json['show_type'],
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

  final String? id,
      title,
      hostId,
      hostProfileImageUrl,
      hostName,
      showType,
      coverUrl,
      startedAt,
      scheduledFor,
      livestreamId,
      showId,
      showTitle,
      showCoverUrl,
      showCategory,
      thumbnailUrl;

  final ProgramType? contentTypeEnum;
  final ProgramStatus? statusEnum;


  final double? price, score;
  final int? viewerCount, goingCount, coHostCount, episodeNumber;
  final bool? requesterFollowsHost, requesterIsGoing;
  final List<String>? avatarUrls;
}

enum ProgramType {
  episode('episode'),
  standalone('standalone');

  const ProgramType(this.value);
  final String value;

  static ProgramType fromJson(String? json) =>
      ProgramType.values.firstWhere(
        (ProgramType e) => e.value == json,
        orElse: () => ProgramType.standalone,
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
