import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:equatable/equatable.dart';

class HostedEventsResponseModel {
  HostedEventsResponseModel({
    this.hostedEvents,
    this.total,
    this.page,
    this.pageSize,
    this.hasMore,
  });

  factory HostedEventsResponseModel.fromJson(Map<String, dynamic> json) {
    return HostedEventsResponseModel(
      hostedEvents: (json['data']['events'] as List<dynamic>?)
          ?.map((dynamic e) => HostedEvent.fromJson(e))
          .toList(),
      total: json['total'],
      page: json['page'],
      pageSize: json['page_size'],
      hasMore: json['has_more'],
    );
  }

  final List<HostedEvent>? hostedEvents;
  final int? total, page, pageSize;
  final bool? hasMore;
}

class HostedEvent extends Equatable {
  const HostedEvent(
      {this.eventId,
      this.title,
      this.description,
      this.coverUrl,
      this.status,
      this.scheduledFor,
      this.startedAt,
      this.endedAt,
      this.streamUrl,
      this.streamKey,
      this.playbackUrl,
      this.livestreamId,
      this.eventType,
      this.viewerCount,
      this.peakViewers,
      this.reactionCount,
      this.commentCount,
      this.goingCount,
      this.durationSeconds,
      this.host,
      this.coHosts,
      this.tags,
      this.publishedAt,
      this.createdAt,
      this.updatedAt,
      this.handRaising,
      this.category,
      this.price,
      this.followerCount,
      this.isLive,
      this.community,
      this.capacity,
      this.whispers,
      this.showType});

  factory HostedEvent.fromJson(Map<String, dynamic> json) {
    return HostedEvent(
      eventId: json['event_id'],
      title: json['title'],
      description: json['description'],
      coverUrl: json['thumbnail_url'],
      status: json['status'],
      scheduledFor: json['scheduled_for'],
      startedAt: json['started_at'],
      endedAt: json['ended_at'],
      streamUrl: json['stream_url'],
      streamKey: json['stream_key'],
      playbackUrl: json['playback_url'],
      livestreamId: json['livestream_id'],
      eventType: json['event_type'],
      viewerCount: json['viewer_count'],
      peakViewers: json['peak_viewers'],
      reactionCount: json['reaction_count'],
      commentCount: json['comment_count'],
      goingCount: json['going_count'],
      durationSeconds: json['duration_seconds'],
      showType: json['show_type'],
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
      handRaising: json['hand_raising'],
      whispers: json['whispers'],
      category: json['category'],
      price: json['price']?.toDouble(),
      followerCount: json['follower_count'],
      isLive: json['is_live'],
      capacity: json['capacity'],
      community: json['community'] != null
          ? Community.fromJson(json['community'])
          : null,
    );
  }

  final String? eventId,
      title,
      description,
      coverUrl,
      status,
      scheduledFor,
      startedAt,
      endedAt,
      streamUrl,
      streamKey,
      playbackUrl,
      livestreamId,
      eventType,
      showType,
      publishedAt,
      createdAt,
      updatedAt;

  final int? viewerCount,
      peakViewers,
      reactionCount,
      commentCount,
      goingCount,
      durationSeconds,
      followerCount,
      capacity;
  final double? price;
  final Host? host;
  final bool? isLive, handRaising, whispers;
  final List<CoHost>? coHosts;
  final List<HashTag>? tags;
  final Community? community;
  final String? category;

  @override
  List<Object?> get props => <Object?>[
        eventId,
        title,
        description,
        coverUrl,
        status,
        scheduledFor,
        startedAt,
        endedAt,
        streamUrl,
        streamKey,
        playbackUrl,
        livestreamId,
        eventType,
        viewerCount,
        peakViewers,
        reactionCount,
        commentCount,
        goingCount,
        durationSeconds,
        host,
        coHosts,
        tags,
        publishedAt,
        createdAt,
        updatedAt,
        handRaising,
        category,
        price,
        followerCount,
        isLive,
        community,
        capacity,
        whispers,
        showType
      ];
}
