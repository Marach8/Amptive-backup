class SignupResponseModel {
  SignupResponseModel({
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      user: json['user'] != null
          ? ATUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );
  }

  ATUser? user;
  String? accessToken, refreshToken;
}

class ATUser {
  ATUser({
    this.id,
    this.email,
    this.username,
    this.dob,
    this.name,
    this.followersCount,
    this.pictureUrl, 
  });

  factory ATUser.fromJson(Map<String, dynamic> json) {
    return ATUser(
      id: json['id'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      dob: json['dob'] as String?,
      name: json['name'] as String?,
      pictureUrl: json['profile_picture'] as String?,
      followersCount: json['followers_count'],
    );
  }
  final String? id, email, username, dob, name, pictureUrl;
  final int ? followersCount;

    
  }



class LoginResponseModel {
  LoginResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? data = json['data'] as Map<String, dynamic>?;

    return LoginResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      user: data?['user'] != null
          ? ATUser.fromJson(data!['user'] as Map<String, dynamic>)
          : null,
      accessToken: data?['access_token'],
      refreshToken: data?['refresh_token'],
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final ATUser? user;
  final String? accessToken, refreshToken;
}
