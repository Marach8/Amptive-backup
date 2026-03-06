class User {
  User({
    this.userId,
    this.username,
    this.displayName,
    this.profileImageUrl,
    this.isVerified,
    this.followersCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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

class Host extends User {
  Host({
    super.userId,
    super.username,
    super.displayName,
    super.profileImageUrl,
    super.isVerified,
    super.followersCount,
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
}

class CoHost extends User {
  CoHost({
    super.userId,
    super.username,
    super.displayName,
    super.profileImageUrl,
    super.isVerified,
    super.followersCount,
  });

  factory CoHost.fromJson(Map<String, dynamic> json) {
    return CoHost(
      userId: json['user_id'],
      username: json['username'],
      displayName: json['display_name'],
      profileImageUrl: json['profile_image_url'],
      isVerified: json['is_verified'],
      followersCount: json['followers_count'],
    );
  }
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
