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
    this.contentType,
    this.status,
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
  });

  factory HomeFeedItem.fromJson(Map<String, dynamic> json) {
    return HomeFeedItem(
      id: json['id'],
      title: json['title'],
      contentType: json['content_type'],
      status: json['status'],
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
    );
  }

  final String? id,
      title,
      contentType,
      status,
      hostId,
      hostProfileImageUrl,
      hostName,
      showType,
      coverUrl,
      startedAt,
      scheduledFor;

  final double? price, score;
  final int? viewerCount, goingCount;
  final bool? requesterFollowsHost, requesterIsGoing;
}
