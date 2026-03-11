class FollowersResponseModel {

  FollowersResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.followers,
    this.hasMore,
    this.limit,
    this.offset

  });

  factory FollowersResponseModel.fromJson(Map<String, dynamic> json) {
    return FollowersResponseModel(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      followers: (json['data'] as List? ?? <dynamic>[])
          .map((dynamic item) => Followers.fromJson(item as Map<String, dynamic>))
          .toList(),
          limit: json['limit'],
      offset: json['offset'],
      hasMore: json['has_more'],
    );
 
  }
  final bool? hasMore, status;
  final int? statusCode, limit, offset;
  final String? message;
  final List<Followers>? followers;
}class Followers {

  Followers({
    this.id,
    this.username,
    this.profilePicture,
  });

  factory Followers.fromJson(Map<String, dynamic> json) {
    return Followers(
      id: json['_id'] ?? json['id'],
      username: json['username'],
      profilePicture: json['profile_picture'] ?? json['avatar'],
    );
  }
  final String? id;
  final String? username;
  final String? profilePicture;
  
}
