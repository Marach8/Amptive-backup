class GetAllUsersResponseModel {
  GetAllUsersResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
    this.page,
    this.pageSize,
    this.hasMore,
  });

  factory GetAllUsersResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAllUsersResponseModel(
      status: json['status'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int?,
      pageSize: json['page_size'] as int?,
      hasMore: json['has_more'] as bool?,
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final List<UserModel>? data;
  final int? page, pageSize;
  final bool? hasMore;
}

class UserModel {
  UserModel({
    this.id,
    this.username,
    this.profilePicture,
    this.followersCount,
    this.followingCount,
    this.firstName,
    this.lastName,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      profilePicture: json['profile_picture'] as String?,
      followersCount: json['followers_count'] as int?,
      followingCount: json['following_count'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      name: json['name'] as String?,
    );
  }

  final String? id, username, profilePicture, firstName, lastName, name;
  final int? followersCount, followingCount;
}
