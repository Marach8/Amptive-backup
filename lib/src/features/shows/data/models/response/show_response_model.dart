
import 'package:equatable/equatable.dart';

class HostedShowsResponseModel {
  HostedShowsResponseModel({
    this.hostedShows,
    this.total,
    this.page,
    this.pageSize,
    this.hasMore,
  });

  factory HostedShowsResponseModel.fromJson(Map<String, dynamic> json) {
    return HostedShowsResponseModel(
      hostedShows: (json['items'] as List<dynamic>?)
          ?.map((dynamic e) => HostedShow.fromJson(e))
          .toList(),
      total: json['total'],
      page: json['page'],
      pageSize: json['page_size'],
      hasMore: json['has_more'],
    );
  }

  final List<HostedShow>? hostedShows;
  final int? total;
  final int? page;
  final int? pageSize;
  final bool? hasMore;
}



class HostedShow extends Equatable {
  const HostedShow({
    this.showId,
    this.title,
    this.description,
    this.coverUrl,
    this.category,
    this.showType,
    this.price,
    this.status,
    this.episodeCount,
    this.totalViewers,
    this.goingCount,
    this.followerCount,
    this.host,
    this.coHosts,
    this.tags,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.activeEpisode,
  });

  factory HostedShow.fromJson(Map<String, dynamic> json) {
    return HostedShow(
      showId: json['show_id'],
      title: json['title'],
      description: json['description'],
      coverUrl: json['cover_url'],
      category: json['category'],
      showType: json['show_type'],
      price: json['price']?.toDouble(),
      status: json['status'],
      episodeCount: json['episode_count'],
      totalViewers: json['total_viewers'],
      goingCount: json['going_count'],
      followerCount: json['follower_count'],
      host: json['host'] != null ? Host.fromJson(json['host']) : null,
      coHosts: (json['co_hosts'] as List<dynamic>?)
          ?.map((dynamic e) => Host.fromJson(e))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((dynamic e) => Tag.fromJson(e))
          .toList(),
      publishedAt: json['published_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      activeEpisode: json['active_episode'] != null
          ? Episode.fromJson(json['active_episode'])
          : null,
    );
  }

  final String? showId,
      title,
      description,
      coverUrl,
      category,
      showType,
      status,
      publishedAt,
      createdAt,
      updatedAt;

  final double? price;

  final int? episodeCount,
      totalViewers,
      goingCount,
      followerCount;

  final Host? host;
  final List<Host>? coHosts;
  final List<Tag>? tags;
  final Episode? activeEpisode;

  @override
  List<Object?> get props => <Object?>[
        showId,
        title,
        description,
        coverUrl,
        category,
        showType,
        price,
        status,
        episodeCount,
        totalViewers,
        goingCount,
        followerCount,
        host,
        coHosts,
        tags,
        publishedAt,
        createdAt,
        updatedAt,
        activeEpisode,
      ];
}



class Host {
  Host({
    this.userId,
    this.username,
    this.displayName,
    this.profileImageUrl,
    this.isVerified,
    this.followersCount,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      userId: json['user_id'],
      username: json['username'],
      displayName: json['display_name'],
      profileImageUrl: json['profile_image_url'],
      isVerified: json['is_verified'],
      followersCount: json['followers_count'],
    );
  }

  final String? userId, username, displayName, profileImageUrl;
  final bool? isVerified;
  final int? followersCount;
}

class Tag {
  Tag({
    this.id,
    this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
    );
  }

  final String? id, name;
}

class Episode {
  Episode({
    this.episodeId,
    this.episodeNumber,
    this.title,
    this.thumbnailUrl,
    this.status,
    this.scheduledFor,
    this.startedAt,
    this.endedAt,
    this.viewerCount,
    this.goingCount,
    this.durationSeconds,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeId: json['episode_id'],
      episodeNumber: json['episode_number'],
      title: json['title'],
      thumbnailUrl: json['thumbnail_url'],
      status: json['status'],
      scheduledFor: json['scheduled_for'],
      startedAt: json['started_at'],
      endedAt: json['ended_at'],
      viewerCount: json['viewer_count'],
      goingCount: json['going_count'],
      durationSeconds: json['duration_seconds'],
    );
  }

  final String? episodeId,
      title,
      thumbnailUrl,
      status,
      scheduledFor,
      startedAt,
      endedAt;

  final int? episodeNumber,
      viewerCount,
      goingCount,
      durationSeconds;
}
