class User {
  User({
    this.id,
    this.username,
    this.profilePicture,
    this.followersCount,
    this.followingCount,
    this.firstName,
    this.lastName,
    this.name,
    this.isVerified,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        profilePicture = json['profile_picture'],
        followersCount = json['followers_count'],
        followingCount = json['following_count'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        name = json['name'],
        isVerified = json['is_verified'];

  final String? id, username, profilePicture, firstName, lastName, name;
  final int? followersCount, followingCount;
  final bool? isVerified;
}

class Host extends User {
  Host({
    this.hostLevel,
    this.totalShows,
    super.id,
    super.username,
    super.profilePicture,
    super.followersCount,
    super.followingCount,
    super.firstName,
    super.lastName,
    super.name,
    super.isVerified,
  });

  Host.fromJson(super.json)
      : hostLevel = json['host_level'],
        totalShows = json['total_shows'],
        super.fromJson();

  final int? hostLevel, totalShows;
}

class CoHost extends User {
  CoHost({
    this.invitedAt,
    super.id,
    super.username,
    super.profilePicture,
    super.followersCount,
    super.followingCount,
    super.firstName,
    super.lastName,
    super.name,
    super.isVerified,
  });

  CoHost.fromJson(super.json)
      : invitedAt = json['invited_at'],
        super.fromJson();

  final String? invitedAt;
}

class Community {
  Community({
    this.communityId,
    this.name,
    this.description,
    this.image,
    this.memberCount,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      communityId: json['community_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      memberCount: json['member_count'],
    );
  }

  final String? communityId, name, description, image;
  final int? memberCount;
}

class HashTag {
  const HashTag({
    this.id,
    this.name,
    this.displayName,
    this.description,
    this.usageCount,
    this.followerCount,
    this.createdAt,
    this.updatedAt,
  });

  factory HashTag.fromJson(Map<String, dynamic> json) {
    return HashTag(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      description: json['description'],
      usageCount: json['usage_count'],
      followerCount: json['follower_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  final String? id, name, displayName, description, createdAt, updatedAt;
  final int? usageCount, followerCount;

  HashTag copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? createdAt,
    String? updatedAt,
    int? usageCount,
    int? followerCount,
  }) {
    return HashTag(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usageCount: usageCount ?? this.usageCount,
      followerCount: followerCount ?? this.followerCount,
    );
  }
}


class Episode {
  Episode({
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
      updatedAt;

  final int? episodeNumber,
      viewerCount,
      peakViewers,
      reactionCount,
      commentCount,
      goingCount,
      durationSeconds;

  final bool? handRaising, whispers;

  final Host? host;
  final List<CoHost>? coHosts;
  final Community? community;
  final List<HashTag>? tags;
}
