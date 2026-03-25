import 'dart:developer';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';
import 'package:amptive/src/features/profile/data/models/followers_response_model.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:dio/dio.dart';

class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<UserProfileResponseModel>> fetchUserProfile() async {
    try {
      final Response<dynamic> response =
          await networkService.get(ATEndpoints.getUserprofile);
      final UserProfileResponseModel userProfile = UserProfileResponseModel.fromJson(response.data);
      return Successful<UserProfileResponseModel>(data: userProfile);
    } catch (e) {
      log('Error in getting user profile');
      return Unsuccessful<UserProfileResponseModel>(
          
          error: ATException.resolveException(e));
    }
  }

  @override
Future<ApiResponse<dynamic>> updateUserProfile({
  String? profilePicture,
  String? name,
  String? username,
  String? bio,
  String? country,
  String? coverPhoto,
  String? xUrl,
  String? instagramUrl,
  String? linkedinUrl,
  String? websiteUrl,
}) async {
  try {
    final Map<String, dynamic> body = <String, dynamic>{};
    
    if (profilePicture != null) body["profile_picture"] = profilePicture;
    if (name != null) body["name"] = name;
    if (username != null) body["username"] = username;
    if (bio != null) body["bio"] = bio;
    if (country != null) body["country"] = country;
    if (coverPhoto != null) body["cover_photo"] = coverPhoto;
    if (xUrl != null) body["x_url"] = xUrl;
    if (instagramUrl != null) body["instagram_url"] = instagramUrl;
    if (linkedinUrl != null) body["linkedin_url"] = linkedinUrl;
    if (websiteUrl != null) body["website_url"] = websiteUrl;

    final Response<dynamic> response = await networkService.patch(
      ATEndpoints.updateUserProfile,
      data: body,
    );
    return Successful<dynamic>(data: response.data);
  } catch (e) {
    return Unsuccessful<dynamic>(error: ATException.resolveException(e));
  }
}


  
   @override
  Future <ApiResponse<FollowersResponseModel>> fetchFollowers ({
    required int page,
    required int pageSize,
  }) async {
    
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.followers,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );
      return Successful<FollowersResponseModel>(data: FollowersResponseModel.fromJson(response.data));
    } catch (e) {
      log('Error in getting followers');
      return Unsuccessful<FollowersResponseModel>(error: ATException.resolveException(e));
    }
  }

  @override
Future<ApiResponse<String>> sendEmailAndPhoneOtp({required Map<String, dynamic> param}) async {
  try {
    final Response<dynamic> response = await networkService.patch(
      ATEndpoints.updateEmailAndPhone,
      data: param
    );
    print('📥 sendEmailAndPhoneOtp Response: ${response.data}');
    print('📥 Type: ${response.data.runtimeType}');
    final String otpCode = response.data['data']['otp_code'] as String;
    return Successful<String>(data: otpCode);
  } catch (e) {
    return Unsuccessful<String>(error: ATException.resolveException(e));
  }
}

  @override
  Future<ApiResponse<dynamic>> verifyOtp({
    required Map<String, dynamic> param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.verifyEmailOrPhoneOtp,
        data: param,
      );

      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Verify OTP error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }


}
