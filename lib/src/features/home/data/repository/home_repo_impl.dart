import 'dart:developer' show log;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_hosted_show.dart';
import 'package:dio/dio.dart' show Response;

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<dynamic>> fetchHomeFeed({
    required int page,
    required int pageSize,
    required bool refresh,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.homeFeed,
        queryParameters: <String, dynamic>{
          'page': page,
          'page_size': pageSize,
          'refresh': refresh,
        },
      );

      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Get home feed error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> fetchFollowedShows({
    required int page,
    required int pageSize,
    required bool refresh,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.followedShowsFeed,
        queryParameters: <String, dynamic>{
          'page': page,
          'page_size': pageSize,
          'refresh': refresh,
        },
      );

      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Get followed shows error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> fetchLiveShows({
    required int page,
    required int pageSize,
    required bool refresh,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.liveShowsFeed,
        queryParameters: <String, dynamic>{
          'page': page,
          'page_size': pageSize,
          'refresh': refresh,
        },
      );

      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Get live shows error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }
}
