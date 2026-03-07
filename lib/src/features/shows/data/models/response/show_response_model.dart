import 'package:amptive/src/shared/global_model_objects.dart';
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
          ?.map((dynamic e) => CoHost.fromJson(e))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((dynamic e) => HashTag.fromJson(e))
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
  final int? episodeCount, totalViewers, goingCount, followerCount;
  final Host? host;
  final List<CoHost>? coHosts;
  final List<HashTag>? tags;
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
