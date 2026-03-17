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
    final data = json['data'] ?? <dynamic, dynamic>{};
    final List<dynamic> usersList = (data['users'] as List? ?? <dynamic>[]);

    return FollowersResponseModel(
      status: json['status'] ,
      statusCode: json['status_code'] ,
      message: json['message'] ,
      followers: usersList
          .map((item) => Followers.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: json['page'] ,
      pageSize: json['page_size'] ,
      hasMore: (json['has_more'] ),
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
      profilePicture: json['profile_picture'] ,
      firstName: json['first_name'],
      lastName: json['last_name'],
      name: json['name'],
      followersCount: json['followers_count'] ,
      followingCount: json['following_count'] ,
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
