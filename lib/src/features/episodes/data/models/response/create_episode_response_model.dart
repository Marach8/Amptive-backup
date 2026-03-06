import 'package:amptive/src/shared/global_model_objects.dart';

class CreateEpisodeResponseModel {
  CreateEpisodeResponseModel({
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
    this.createdAt,
    this.updatedAt,
  });

  factory CreateEpisodeResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateEpisodeResponseModel(
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
      viewerCount: json['viewer_count'],
      peakViewers: json['peak_viewers'],
      reactionCount: json['reaction_count'],
      commentCount: json['comment_count'],
      goingCount: json['going_count'],
      durationSeconds: json['duration_seconds'],
      host: json['host'] != null
          ? Host.fromJson(json['host'])
          : null,
      coHosts: (json['co_hosts'] as List<dynamic>?)
          ?.map((dynamic e) => CoHost.fromJson(e))
          .toList(),
      community: json['community'] != null
          ? Community.fromJson(json['community'])
          : null,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((dynamic e) => HashTag.fromJson(e))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  final String? episodeId, showId, title, description, thumbnailUrl, status,
      scheduledFor, startedAt, endedAt, streamUrl, streamKey, playbackUrl,
      createdAt, updatedAt;

  final int? episodeNumber, viewerCount, peakViewers, reactionCount,
      commentCount, goingCount, durationSeconds;

  final Host? host;
  final List<CoHost>? coHosts;
  final Community? community;
  final List<HashTag>? tags;
}
