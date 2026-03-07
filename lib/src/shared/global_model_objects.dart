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

  final String? id, username, profilePicture, firstName,
  lastName, name;
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
  HashTag({
    this.id,
    this.name,
  });

  factory HashTag.fromJson(Map<String, dynamic> json) {
    return HashTag(
      id: json['id'],
      name: json['name'],
    );
  }

  final String? id, name;
}
