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
  ProfileRepoImpl({
    NetworkService ? mockNetworkService
  }): networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future <ApiResponse<UserProfileResponseModel>> fetchUserProfile () async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.getUserprofile
      );
      final userProfile = UserProfileResponseModel.fromJson(response.data);
      return Successful<UserProfileResponseModel>(data: userProfile);
    } catch (e) {
      log('Error in getting user profile');
      return Unsuccessful<UserProfileResponseModel>(error: ATException.resolveException(e));
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
}
