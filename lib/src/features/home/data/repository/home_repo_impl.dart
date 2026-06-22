import 'dart:developer';
import 'dart:developer' show log;
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/data/models/response/going_status.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:dio/dio.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/data/models/response/live_users_response_model.dart';
import 'package:dio/dio.dart' show Response;

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<FollowingStatus>> unFollowTargetUser(
      {required String targetUserId}) async {
    try {
      final Response<dynamic> response = await networkService.delete(
        '${ATEndpoints.usersShows}/$targetUserId/follow',
      );

      return Successful<FollowingStatus>(
          data: FollowingStatus.fromJson(
        response.data,
      ));
    } catch (e) {
      log('error in unfollowing user: $e');
      return Unsuccessful<FollowingStatus>(
          error: ATException.resolveException(e));
    }
  }

  @override
  Future<ApiResponse<FollowingStatus>> followTargetUser(
      {required String targetUserId}) async {
    try {
      final Response<dynamic> response = await networkService.post(
        '${ATEndpoints.usersShows}/$targetUserId/follow',
      );

      return Successful<FollowingStatus>(
          data: FollowingStatus.fromJson(
        response.data,
      ));
    } catch (e) {
      log('error in unfollowing user: $e');
      return Unsuccessful<FollowingStatus>(
          error: ATException.resolveException(e));
    }
  }

  @override
  Future<ApiResponse<HomeFeedResponseModel>> fetchHomeFeed({
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
          'refresh': refresh
        },
      );

      return Successful<HomeFeedResponseModel>(
        data: HomeFeedResponseModel.fromJson(
            response.data),
      );
    } catch (e) {
      log('Get home feed error: $e');
      return Unsuccessful<HomeFeedResponseModel>(
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
  Future<ApiResponse<LiveUsersResponseModel>> fetchLiveUsers({
    required int page,
    required int pageSize,
    required bool refresh,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.liveUsersFeed,
        queryParameters: <String, dynamic>{
          'page': page,
          'page_size': pageSize,
          'refresh': refresh,
        },
      );

      return Successful<LiveUsersResponseModel>(
        data: LiveUsersResponseModel.fromJson(response.data),
      );
    } catch (e) {
      log('Get live shows error: $e');
      return Unsuccessful<LiveUsersResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<GoingStatus>> markAsGoing({
    required String contentId,
    required GoingType type,
  }) async {
    try {
      final String endpoint = type == GoingType.event
          ? '${ATEndpoints.standaloneEvents}$contentId/going'
          : '${ATEndpoints.episodeEvents}$contentId/going';

      final Response<dynamic> response = await networkService.post(endpoint);

      return Successful<GoingStatus>(
        data: GoingStatus.fromJson(response.data),
      );
    } catch (e) {
      log('Mark as going error: $e');
      return Unsuccessful<GoingStatus>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<GoingStatus>> unmarkGoing({
    required String contentId,
    required GoingType type,
  }) async {
    try {
      final String endpoint = type == GoingType.event
          ? '${ATEndpoints.standaloneEvents}$contentId/going'
          : '${ATEndpoints.episodeEvents}$contentId/going';

      final Response<dynamic> response = await networkService.delete(endpoint);

      return Successful<GoingStatus>(
        data: GoingStatus.fromJson(response.data),
      );
    } catch (e) {
      log('Unmark going error: $e');
      return Unsuccessful<GoingStatus>(
        error: ATException.resolveException(e),
      );
    }
  }
}
