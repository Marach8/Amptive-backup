import 'package:amptive/src/shared/global_model_objects.dart';

String? _nonEmptyString(dynamic value) {
  if (value is! String) return null;
  final String trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String? _communityNameFrom(dynamic value) {
  if (value is String) return _nonEmptyString(value);
  if (value is! Map) return null;

  return _nonEmptyString(value['name']) ??
      _nonEmptyString(value['title']) ??
      _nonEmptyString(value['community_name']);
}

String? _extractCommunityName(Map<String, dynamic> json) {
  final dynamic show = json['show'];
  final dynamic event = json['event'];

  return _nonEmptyString(json['community_name']) ??
      _nonEmptyString(json['communityName']) ??
      _nonEmptyString(json['show_community_name']) ??
      _nonEmptyString(json['event_community_name']) ??
      _communityNameFrom(json['community']) ??
      (show is Map ? _communityNameFrom(show['community']) : null) ??
      (event is Map ? _communityNameFrom(event['community']) : null) ??
      _nonEmptyString(json['show_category']) ??
      _nonEmptyString(json['category']);
}

List<HashTag>? _extractTags(Map<String, dynamic> json) {
  final dynamic show = json['show'];
  final dynamic event = json['event'];
  final dynamic episode = json['episode'];
  final dynamic rawTags = json['tags'] ??
      json['hashtags'] ??
      (show is Map ? show['tags'] : null) ??
      (event is Map ? event['tags'] : null) ??
      (episode is Map ? episode['tags'] : null);

  if (rawTags is! List) return null;

  return rawTags
      .map<HashTag>((dynamic tag) {
        if (tag is String) return HashTag(name: tag);
        if (tag is Map) {
          return HashTag.fromJson(<String, dynamic>{
            ...tag.cast<String, dynamic>(),
            'name': tag['name'] ?? tag['display_name'] ?? tag['tag_name'],
          });
        }
        return const HashTag();
      })
      .where((HashTag tag) => tag.name?.trim().isNotEmpty ?? false)
      .toList();
}

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
    this.livestreamId,
    this.coHostCount,
    this.coHosts,
    this.avatarUrls,
    this.showId,
    this.showTitle,
    this.showCoverUrl,
    this.showCategory,
    this.communityName,
    this.tags,
    this.episodeNumber,
    this.thumbnailUrl,
    this.description,
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
      livestreamId: json['livestream_id'],
      coHostCount: (json['co_hosts'] as List<dynamic>?)?.length ?? 0,
      coHosts: (json['co_hosts'] as List<dynamic>?)?.map((dynamic e) {
        final Map<String, dynamic> map = e as Map<String, dynamic>;
        return CoHost.fromJson(<String, dynamic>{
          'user_id': map['id'] ?? map['user_id'],
          'username': map['username'],
          'profile_picture': map['avatar_url'] ?? map['profile_picture'],
          ...map,
        });
      }).toList(),
      avatarUrls: (json['avatar_urls'] as List<dynamic>?)
          ?.map((dynamic e) => e as String)
          .toList(),
      showId: json['show_id'],
      showTitle: json['show_title'],
      showCoverUrl: json['show_cover_url'],
      showCategory: json['show_category'],
      communityName: _extractCommunityName(json),
      tags: _extractTags(json),
      episodeNumber: json['episode_number'],
      thumbnailUrl: json['thumbnail_url'] as String?,
      description: json['description'] ??
          (json['show'] is Map ? json['show']['description'] : null) ??
          (json['event'] is Map ? json['event']['description'] : null) ??
          (json['episode'] is Map ? json['episode']['description'] : null),
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
      scheduledFor,
      livestreamId,
      showId,
      showTitle,
      showCoverUrl,
      showCategory,
      communityName,
      thumbnailUrl,
      description;

  final double? price, score;
  final int? viewerCount, goingCount, coHostCount, episodeNumber;
  final List<CoHost>? coHosts;
  final List<HashTag>? tags;
  final bool? requesterFollowsHost, requesterIsGoing;
  final List<String>? avatarUrls;
}
