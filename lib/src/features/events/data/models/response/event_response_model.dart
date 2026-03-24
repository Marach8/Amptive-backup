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
      hostedEvents: (json['items'] as List<dynamic>?)
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
  const HostedEvent({
    this.eventId,
    this.title,
    this.description,
    this.coverUrl,
    this.category,
    this.eventType,
    this.price,
    this.status,
    this.totalViewers,
    this.goingCount,
    this.followerCount,
    this.host,
    this.coHosts,
    this.tags,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.startTime,
    this.endTime,
    this.location,
    this.isLive,
    this.community,
  });

  factory HostedEvent.fromJson(Map<String, dynamic> json) {
    return HostedEvent(
      eventId: json['event_id'],
      title: json['title'],
      description: json['description'],
      coverUrl: json['cover_url'],
      category: json['category'],
      eventType: json['event_type'],
      price: json['price']?.toDouble(),
      status: json['status'],
      totalViewers: json['total_viewers'],
      goingCount: json['going_count'],
      followerCount: json['follower_count'],
      isLive: json['is_live'],
      host: json['host'] != null ? Host.fromJson(json['host']) : null,
      coHosts: (json['co_hosts'] as List<dynamic>?)
          ?.map((dynamic e) => CoHost.fromJson(e))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((dynamic e) => HashTag.fromJson(e))
          .toList(),
      publishedAt: json['published_at'],
      createdAt: json['created_at'],
      community: json['community'],
      updatedAt: json['updated_at'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      location: json['location'],
    );
  }

  final String? eventId,
      title,
      description,
      coverUrl,
      category,
      eventType,
      status,
      publishedAt,
      createdAt,
      updatedAt,
      startTime,
      endTime,
      location;

  final double? price;
  final int? totalViewers, goingCount, followerCount;
  final Host? host;
  final bool? isLive;
  final List<CoHost>? coHosts;
  final List<HashTag>? tags;
  final Community? community;

  @override
  List<Object?> get props => <Object?>[
        eventId,
        title,
        description,
        coverUrl,
        category,
        eventType,
        price,
        status,
        totalViewers,
        goingCount,
        followerCount,
        host,
        coHosts,
        tags,
        publishedAt,
        createdAt,
        updatedAt,
        startTime,
        endTime,
        location,
        isLive,
        community,
      ];
}
