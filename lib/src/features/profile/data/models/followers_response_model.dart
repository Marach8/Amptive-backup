class FollowersResponseModel {
  FollowersResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.followers,
    this.hasMore,
    this.page,
    this.pageSize,
  });

  factory FollowersResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final usersList = (data['users'] as List? ?? <dynamic>[]);

    return FollowersResponseModel(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      followers: usersList
          .map((item) => Followers.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? usersList.length,
      hasMore: (json['page'] ?? 1) < (json['total_pages'] ?? 1),
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Followers>? followers;
  final int? page;
  final int? pageSize;
  final bool? hasMore;
}

class Followers {
  Followers({
    this.id,
    this.username,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.name,
    this.followersCount,
    this.followingCount,
  });

  factory Followers.fromJson(Map<String, dynamic> json) {
    return Followers(
      id: json['id'] ?? json['_id'],
      username: json['username'],
      profilePicture: json['profile_picture'] ?? json['avatar'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      name: json['name'],
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
    );
  }

  final String? id;
  final String? username;
  final String? profilePicture;
  final String? firstName;
  final String? lastName;
  final String? name;
  final int? followersCount;
  final int? followingCount;
}
