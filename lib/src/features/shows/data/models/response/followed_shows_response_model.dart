import 'package:amptive/src/shared/global_model_objects.dart';

class FollowedShowsResponseModel {
  FollowedShowsResponseModel({
    this.items,
    this.page,
    this.pageSize,
    this.hasMore,
  });

  factory FollowedShowsResponseModel.fromJson(Map<String, dynamic> json) {
    return FollowedShowsResponseModel(
      items: (json['items'] as List<dynamic>?)
          ?.map((dynamic e) => FollowedShowItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'],
      pageSize: json['page_size'],
      hasMore: json['has_more'],
    );
  }

  final List<FollowedShowItem>? items;
  final int? page, pageSize;
  final bool? hasMore;
}

class FollowedShowItem {
  FollowedShowItem({
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
    this.thumbnailUrl,
    this.startedAt,
    this.scheduledFor,
    this.score,
    this.requesterFollowsHost,
    this.requesterIsGoing,
    this.livestreamId,
    this.avatarUrls,
    this.coHosts,
    this.showId,
    this.showTitle,
    this.showCoverUrl,
    this.showCategory,
    this.episodeNumber,
  });

  factory FollowedShowItem.fromJson(Map<String, dynamic> json) {
    return FollowedShowItem(
      id: json['id'],
      title: json['title'],
      contentType: json['content_type'],
      status: json['status'],
      hostId: json['host_id'],
      hostProfileImageUrl: json['host_profile_image_url'],
      hostName: json['host_name'],
      showType: json['show_type'],
      price: (json['price'] as num?)?.toDouble(),
      viewerCount: json['viewer_count'],
      goingCount: json['going_count'],
      coverUrl: json['cover_url'],
      thumbnailUrl: json['thumbnail_url'],
      startedAt: json['started_at'],
      scheduledFor: json['scheduled_for'],
      score: (json['score'] as num?)?.toDouble(),
      requesterFollowsHost: json['requester_follows_host'],
      requesterIsGoing: json['requester_is_going'],
      livestreamId: json['livestream_id'],
      avatarUrls: (json['avatar_urls'] as List<dynamic>?)
          ?.map((dynamic e) => e as String)
          .toList(),
      coHosts: (json['co_hosts'] as List<dynamic>?)
          ?.map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      showId: json['show_id'],
      showTitle: json['show_title'],
      showCoverUrl: json['show_cover_url'],
      showCategory: json['show_category'],
      episodeNumber: json['episode_number'],
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
      thumbnailUrl,
      startedAt,
      scheduledFor,
      livestreamId,
      showId,
      showTitle,
      showCoverUrl,
      showCategory;

  final double? price, score;
  final int? viewerCount, goingCount, episodeNumber;
  final bool? requesterFollowsHost, requesterIsGoing;
  final List<String>? avatarUrls;
  final List<User>? coHosts;
}
