class SignupResponseModel {
  SignupResponseModel({
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );
  }

  User? user;
  String? accessToken, refreshToken;
}


class User {
  User({
    this.id,
    this.email,
    this.username,
    this.dob,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      dob: json['dob'] as String?,
      name: json['name'] as String?,
    );
  }

  String? id, email, username, dob, name;
}
