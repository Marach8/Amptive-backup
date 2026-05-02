import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class User extends Equatable{
  const User({
    required this.userId,
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
      : userId = json['user_id'],
        username = json['username'],
        profilePicture = json['profile_picture'],
        followersCount = json['followers_count'],
        followingCount = json['following_count'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        name = json['name'],
        isVerified = json['is_verified'];

  final String userId;
  final String? username, profilePicture,
    firstName, lastName, name;
  final int? followersCount, followingCount;
  final bool? isVerified;

  @override 
  List<Object?> get props => <Object?>[
    userId, profilePicture,
  ];
}

class Host extends User {
  const Host({
    this.hostLevel,
    this.totalShows,
    required super.userId,
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
  const CoHost({
    this.invitedAt,
    required super.userId,
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
    this.isPrivate,
    this.creatorId
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      communityId: json['community_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      memberCount: json['member_count'],
      isPrivate: json['is_private'],
      creatorId: json['created_by']
    );
  }

  final String? communityId, name, description,
    image, creatorId;
  final int? memberCount;
  bool? isPrivate;
}

class HashTag extends Equatable{
  const HashTag({
    this.id,
    this.name,
    this.displayName,
    this.description,
    this.usageCount,
    this.followerCount,
    this.createdAt,
    this.updatedAt,
    this.tagType,
    this.icon,
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
      tagType: json['tag_type'],
      icon: json['icon'],
    );
  }

  final String? id, name, displayName, description,
    createdAt, updatedAt, tagType, icon;
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
    String? tagType,
    String? icon, 
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
      tagType: tagType ?? this.tagType,
      icon: icon ?? this.icon,
    );
  }
  
  @override
  List<Object?> get props => <Object?>[
    id, name,
  ];
}
