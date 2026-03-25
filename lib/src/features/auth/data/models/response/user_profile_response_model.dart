class UserProfileResponseModel {
  UserProfileResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
    this.errors,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UserProfileResponseModel(
      status: json['status'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'],
      data: json['data'] != null
          ? UserData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final UserData? data;
  final Map<String, dynamic>? errors;
}

class UserData {
  UserData({
    this.id,
    this.email,
    this.username,
    this.dob,
    this.name,
    this.pictureUrl,
    this.followersCount,
    this.bio,
    this.xUrl,
    this.instagramUrl,
    this.linkedinUrl,
    this.websiteUrl,
    this.phoneNumber,

  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ,
      email: json['email'] ,
      username: json['username'] ,
      dob: json['dob'] ,
      name: json['name'] ,
      pictureUrl: json['picture_url'] ,
      followersCount: json['followers_count']?.toString(),
      bio: json['bio'],
      xUrl: json['x_url'],
      instagramUrl: json['instagram_url'],
      linkedinUrl: json['linkedin_url'],
      websiteUrl: json['website_url'],
      phoneNumber: json['phone_number'],


    );
  }

  final String? id, 
  email,
  username,
  dob,
  name,
  pictureUrl, 
  followersCount,
  bio,
  xUrl,
  instagramUrl,
  linkedinUrl,
  phoneNumber,
  websiteUrl;
}
