import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'dart:developer';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/data/models/followers_response_model.dart';
import 'package:amptive/src/features/profile/data/models/request/upgrade_account_data.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:dio/dio.dart';

class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<ProfileData>> fetchUserProfile() async {
    try {
      final Response<dynamic> response =
          await networkService.get(ATEndpoints.getUserprofile);
      final ProfileData userProfile = ProfileData
        .fromRemoteJson(response.data['data']);
      return Successful<ProfileData>(data: userProfile);
    } catch (e) {
      log('Error in getting user profile');
      return Unsuccessful<ProfileData>(
          error: ATException.resolveException(e));
    }
  }

  @override
  Future<ApiResponse<ProfileData>> updateUserProfile({
    required ProfileData userProfileData,
  }) async {
    try {
      final Map<String, dynamic> body = userProfileData.toRemoteJson();

      final Response<dynamic> response = await networkService.patch(
        ATEndpoints.myself,
        data: body,
      );
      final ProfileData updatedProfile = 
        ProfileData.fromRemoteJson(response.data['data']);
      return Successful<ProfileData>(data: updatedProfile);
    } catch (e) {
      return Unsuccessful<ProfileData>(
        error: ATException.resolveException(e));
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
        queryParameters: <String, dynamic>{
          'page': page,
          'page_size': pageSize,
        },
      );
      return Successful<FollowersResponseModel>(
        data: FollowersResponseModel.fromJson(response.data));
    } catch (e) {
      log('Error in getting followers');
      return Unsuccessful<FollowersResponseModel>(
        error: ATException.resolveException(e));
    }
  }

  @override
Future<ApiResponse<String>> sendEmailAndPhoneOtp(
  {required Map<String, dynamic> param}) async {
  try {
    final Response<dynamic> response = await networkService.patch(
      ATEndpoints.updateEmailAndPhone,
      data: param
    );
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

  @override
  Future<ApiResponse<dynamic>> upgradeAccount({
    required UpgradeProfileData param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.upgradeAccount,
        data: param.toJson(),
      );

      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Create Professional Profile error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }
}
