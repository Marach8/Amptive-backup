import 'dart:developer';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/home/data/models/follow_creator_response_model.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:dio/dio.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;
  @override
  Future<ApiResponse<FollowResponseModel>> followCreator(
      {required String targetUserId}) async {
    try {
      final Response<dynamic> response = await networkService.post(
        '${ATEndpoints.followCreator}/$targetUserId/follow',
      );
      return Successful<FollowResponseModel>(
        data: FollowResponseModel.fromJson(response.data as Map<String, dynamic>)
        );
    } catch (e) {
      log('Follow creator error: $e');
      return Unsuccessful<FollowResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }

   @override
  Future<ApiResponse<FollowResponseModel>> unFollowCreator(
      {required String targetUserId}) async {
    try {
      final Response<dynamic> response = await networkService.delete(
        '${ATEndpoints.followCreator}/$targetUserId/follow',
      );
      return Successful<FollowResponseModel>(
        data: FollowResponseModel.fromJson(response.data as Map<String, dynamic>)
        );
    } catch (e) {
      log('error in following user: $e');
      return Unsuccessful<FollowResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }
}
