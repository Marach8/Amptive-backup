import 'dart:developer';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:dio/dio.dart';
import 'package:amptive/src/features/discover/data/models/response/get_all_users_response_model.dart';

class DiscoverRepoImpl implements DiscoverRepo {
  DiscoverRepoImpl({
    NetworkService? mockNetworkService,
  }) : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<CommunitiesResponseModel>> fetchCommunities({
    required int pageNo,
    required int pageSize,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.communities,
        queryParameters: <String, dynamic>{
          'page': pageNo,
          'page_size': pageSize,
        },
      );

      final CommunitiesResponseModel communitiesResponse =
          CommunitiesResponseModel.fromJson(response.data);
      return Successful<CommunitiesResponseModel>(data: communitiesResponse);
    } catch (e) {
      log('Unable to get communities: $e');
      return Unsuccessful<CommunitiesResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<AllUsersResponseModel>> fetchAllUsers({
    required int page,
    required int pageSize,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.getUsers,
        queryParameters: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
        },
      );
      return Successful<AllUsersResponseModel>(
        data: AllUsersResponseModel.fromJson(response.data),
      );
    } catch (e) {
      log('Error in fetching users');
      return Unsuccessful<AllUsersResponseModel>(
          error: ATException.resolveException(e));
    }
  }

  @override
  Future<ApiResponse<dynamic>> fetchTags({
    required int page,
    required int pageSize,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.tags,
        queryParameters: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
        },
      );
      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Error in fetching tags: $e');
      return Unsuccessful<dynamic>(error: ATException.resolveException(e));
    }
  }
}
