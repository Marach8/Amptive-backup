import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:equatable/equatable.dart';

class Episode extends Equatable{
  const Episode({
    this.episodeId,
    this.showId,
    this.episodeNumber,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.status,
    this.scheduledFor,
    this.startedAt,
    this.endedAt,
    this.streamUrl,
    this.streamKey,
    this.playbackUrl,
    this.livestreamId,
    this.viewerCount,
    this.peakViewers,
    this.reactionCount,
    this.commentCount,
    this.goingCount,
    this.durationSeconds,
    this.host,
    this.coHosts,
    this.community,
    this.tags,
    this.handRaising,
    this.createdAt,
    this.updatedAt,
    this.whispers,
    this.priceOverride,
    this.showTypeOverride,
    this.parentShowTitle,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeId: json['episode_id'],
      showId: json['show_id'],
      episodeNumber: json['episode_number'],
      title: json['title'],
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      status: json['status'],
      scheduledFor: json['scheduled_for'],
      startedAt: json['started_at'],
      endedAt: json['ended_at'],
      streamUrl: json['stream_url'],
      streamKey: json['stream_key'],
      playbackUrl: json['playback_url'],
      livestreamId: json['livestream_id'],
      viewerCount: json['viewer_count'],
      peakViewers: json['peak_viewers'],
      reactionCount: json['reaction_count'],
      commentCount: json['comment_count'],
      goingCount: json['going_count'],
      durationSeconds: json['duration_seconds'],
      host: json['host'] != null ? Host.fromJson(json['host']) : null,
      coHosts: (json['co_hosts'] as List<dynamic>?)
          ?.map((dynamic e) => CoHost.fromJson(e as Map<String, dynamic>))
          .toList(),
      community: json['community'] != null
          ? Community.fromJson(json['community'])
          : null,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((dynamic e) => HashTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      handRaising: json['hand_raising'],
      whispers: json['whispers'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      priceOverride: json['price_override'],
      showTypeOverride: json['show_type_override'],
    );
  }

  /// CopyWith that only changes showId
  Episode copyWith({
    String? showId,
    String? parentShowTitle,
  }) {
    return Episode(
      episodeId: episodeId,
      showId: showId ?? this.showId,
      episodeNumber: episodeNumber,
      title: title,
      parentShowTitle: parentShowTitle ?? this.parentShowTitle,
      description: description,
      thumbnailUrl: thumbnailUrl,
      status: status,
      scheduledFor: scheduledFor,
      startedAt: startedAt,
      endedAt: endedAt,
      streamUrl: streamUrl,
      streamKey: streamKey,
      playbackUrl: playbackUrl,
      livestreamId: livestreamId,
      viewerCount: viewerCount,
      peakViewers: peakViewers,
      reactionCount: reactionCount,
      commentCount: commentCount,
      goingCount: goingCount,
      durationSeconds: durationSeconds,
      host: host,
      coHosts: coHosts,
      community: community,
      tags: tags,
      handRaising: handRaising,
      createdAt: createdAt,
      updatedAt: updatedAt,
      whispers: whispers,
      priceOverride: priceOverride,
      showTypeOverride: showTypeOverride,
    );
  }

  final String? episodeId,
      showId,
      title,
      description,
      thumbnailUrl,
      status,
      scheduledFor,
      startedAt,
      endedAt,
      streamUrl,
      streamKey,
      playbackUrl,
      livestreamId,
      createdAt,
      updatedAt,
      showTypeOverride,
      parentShowTitle;

  final int? episodeNumber,
      viewerCount,
      peakViewers,
      reactionCount,
      commentCount,
      goingCount,
      durationSeconds;

  final bool? handRaising, whispers;
  final double? priceOverride;

  final Host? host;
  final List<CoHost>? coHosts;
  final Community? community;
  final List<HashTag>? tags;
  
  @override
  List<Object?> get props => <Object?>[
    episodeId,
    showId,
    episodeNumber,
    title,
    description,
    thumbnailUrl,
    status,
    scheduledFor,
    startedAt,
    endedAt,
    streamUrl,
    streamKey,
    playbackUrl,
    parentShowTitle,
    livestreamId,
    viewerCount,
    peakViewers,
    reactionCount,
    commentCount,
    goingCount,
    durationSeconds,
    host,
    coHosts,
    community,
    tags,
    handRaising,
    createdAt,
    updatedAt,
    whispers,
    priceOverride,
    showTypeOverride,
  ];
}
