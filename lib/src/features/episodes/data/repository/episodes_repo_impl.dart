import 'dart:developer' show log;
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episodes_response_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:dio/dio.dart' show Response;

class EpisodesRepoImpl implements EpisodesRepo {
  EpisodesRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  static final Map<String, Episode> episodeCache = {};
  static final Set<String> fetchingEpisodes = {};

  static Episode? getCachedEpisode(String episodeId) => episodeCache[episodeId];

  @override
  Future<ApiResponse<Episode>> createEpisode({
    required String showId,
    required CreateEpisodePayload episodeData,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        '${ATEndpoints.shows}$showId/episodes',
        data: episodeData.toJson(),
      );

      final Episode episodeResponse =
          Episode.fromJson(response.data);
      return Successful<Episode>(data: episodeResponse);
    } catch (e) {
      log('Create episode error: $e');
      return Unsuccessful<Episode>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<Episode>> fetchEpisodeDetail({
    required String showId,
    required String episodeId,
  }) async {
    // The endpoint is `shows/<showId>/episodes/<episodeId>`; without both ids
    // it collapses to `shows/episodes/<id>` and 404s. Bail early.
    if (showId.isEmpty || episodeId.isEmpty) {
      return Unsuccessful<Episode>(
        error: OtherExceptions('Missing show or episode id', null),
      );
    }

    if (episodeCache.containsKey(episodeId)) {
      return Successful<Episode>(data: episodeCache[episodeId]!);
    }
    
    if (fetchingEpisodes.contains(episodeId)) {
      return Unsuccessful<Episode>(error: OtherExceptions('Fetching in progress', null));
    }

    try {
      fetchingEpisodes.add(episodeId);
      final Response<dynamic> response = await networkService.get(
        '${ATEndpoints.shows}$showId/episodes/$episodeId',
      );

      final Episode episodeResponse =
          Episode.fromJson(response.data);
          
      episodeCache[episodeId] = episodeResponse;
      fetchingEpisodes.remove(episodeId);
      
      return Successful<Episode>(data: episodeResponse);
    } catch (e) {
      fetchingEpisodes.remove(episodeId);
      log('Fetch episode error: $e');
      return Unsuccessful<Episode>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<Episode>> startEpisode({
    required String showId,
    required String episodeId,
    required String streamUrl,
    required String streamKey,
    required String reason,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        '${ATEndpoints.shows}$showId/episodes/$episodeId/start',
        data: <String, dynamic>{
          'stream_url': streamUrl,
          'stream_key': streamKey,
          'reason': reason,
        },
      );

      final Episode episodeResponse = Episode.fromJson(response.data);
      return Successful<Episode>(data: episodeResponse);
    } catch (e) {
      log('Start episode error: $e');
      return Unsuccessful<Episode>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<Episode>> updateEpisode({
    required String showId,
    required String episodeId,
    required CreateEpisodePayload episodeData,
  }) async {
    try {
      final Response<dynamic> response = await networkService.patch(
        '${ATEndpoints.shows}$showId/episodes/$episodeId',
        data: episodeData.toJson(),
      );

      final Episode episodeResponse =
          Episode.fromJson(response.data);
      return Successful<Episode>(data: episodeResponse);
    } catch (e) {
      log('Update episode error: $e');
      return Unsuccessful<Episode>(
        error: ATException.resolveException(e),
      );
    }
  }


  @override
  Future<ApiResponse<EpisodesResponseModel>> fetchEpisodesOfAShow({
    required String showId,
    required int page,
    required int pageSize,
    required String status,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        '${ATEndpoints.shows}$showId/episodes',
        queryParameters: <String, dynamic>{
          'page': page,
          'page_size': pageSize,
          'status': status,
        },
      );

      final EpisodesResponseModel episodesResponse =
          EpisodesResponseModel.fromJson(response.data);
      return Successful<EpisodesResponseModel>(data: episodesResponse);
    } catch (e) {
      log('Fetch episodes of show error: $e');
      return Unsuccessful<EpisodesResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }
}
