import 'dart:developer' show log;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/shows/data/models/request/create_show_model.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo.dart';
import 'package:dio/dio.dart' show Response;

class ShowsRepoImpl implements ShowsRepo {
  ShowsRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  static final Map<String, HostedShow> showCache = {};
  static final Set<String> fetchingShows = {};

  static HostedShow? getCachedShow(String showId) => showCache[showId];

  @override
  Future<ApiResponse<HostedShow>> fetchShow({
    required String showId,
  }) async {
    if (showCache.containsKey(showId)) {
      return Successful<HostedShow>(data: showCache[showId]!);
    }
    
    if (fetchingShows.contains(showId)) {
      return Unsuccessful<HostedShow>(error: OtherExceptions('Fetching in progress', null));
    }

    try {
      fetchingShows.add(showId);
      final Response<dynamic> response = await networkService.get(
        '${ATEndpoints.shows}$showId',
      );

      final HostedShow showResponse = HostedShow.fromJson(
        response.data as Map<String, dynamic>,
      );
      
      showCache[showId] = showResponse;
      fetchingShows.remove(showId);
      
      return Successful<HostedShow>(data: showResponse);
    } catch (e) {
      fetchingShows.remove(showId);
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
  Future<ApiResponse<HostedShow>> updateShow({
    required String showId,
    required CreateShowPayload payload,
  }) async {
    try {
      // The update endpoint only accepts the mutable fields (title,
      // description, cover art, tags, co-hosts, pricing). Sending immutable
      // ones (category, community, hand_raising) crashes it with a 500.
      final Map<String, dynamic> body = <String, dynamic>{
        'title': payload.title,
        'description': payload.description,
        'cover_url': payload.coverUrl,
        'price': payload.price,
        'tag_ids': payload.tagIds,
        'co_host_ids': payload.coHostIds,
        'co_hosts': payload.coHostIds,
      };
      final Response<dynamic> response = await networkService.patch(
        '${ATEndpoints.shows}$showId',
        data: body,
      );
      final HostedShow showResponse = HostedShow.fromJson(response.data);
      // Keep the cache in sync with the edited show.
      showCache[showId] = showResponse;
      return Successful<HostedShow>(data: showResponse);
    } catch (e) {
      log('Update show error: $e');
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
  Future<ApiResponse<HostedShow>> cancelShow({
    required String showId,
    required String reason,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        '${ATEndpoints.shows}$showId/cancel',
        data: <String, dynamic>{
          'reason': reason,
        },
      );

      final HostedShow showResponse = HostedShow.fromJson(
        response.data as Map<String, dynamic>,
      );
      
      // Update cache
      showCache[showId] = showResponse;

      return Successful<HostedShow>(data: showResponse);
    } catch (e) {
      log('Cancel show error: $e');
      return Unsuccessful<HostedShow>(
        error: ATException.resolveException(e),
      );
    }
  }
}
