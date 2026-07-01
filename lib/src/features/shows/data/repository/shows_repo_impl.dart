import 'dart:developer' show log;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/shows/data/models/request/create_show_model.dart';
import 'package:amptive/src/features/shows/data/models/response/followed_shows_response_model.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo.dart';
import 'package:dio/dio.dart' show Response;

class ShowsRepoImpl implements ShowsRepo {
  ShowsRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<HostedShow>> fetchShow({
    required String showId,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        '${ATEndpoints.shows}$showId',
      );

      final HostedShow showResponse = HostedShow.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Successful<HostedShow>(data: showResponse);
    } catch (e) {
      log('Fetch show error: $e');
      return Unsuccessful<HostedShow>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<HostedShow>> createShow({
    required CreateShowPayload createShowModel,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.shows,
        data: createShowModel.toJson(),
      );

      final HostedShow showResponse = HostedShow.fromJson(
        response.data,
      );
      return Successful<HostedShow>(data: showResponse);
    } catch (e) {
      log('Create show error: $e');
      return Unsuccessful<HostedShow>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<HostedShowsResponseModel>> fetchHostedShows({
    required int page,
    required int pageSize,
    required bool refresh,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.shows,
        queryParameters: <String, dynamic>{
          'page': page,
          'page_size': pageSize,
          'refresh': refresh,
        },
      );

      final HostedShowsResponseModel hostedShowsResponse =
          HostedShowsResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Successful<HostedShowsResponseModel>(data: hostedShowsResponse);
    } catch (e) {
      log('Get shows error: $e');
      return Unsuccessful<HostedShowsResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }

    @override
  Future<ApiResponse<FollowedShowsResponseModel>> fetchFollowedShows({
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

      final FollowedShowsResponseModel followedShowsResponse =
          FollowedShowsResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Successful<FollowedShowsResponseModel>(data: followedShowsResponse);
    } catch (e) {
      log('Get followed shows error: $e');
      return Unsuccessful<FollowedShowsResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }
}
