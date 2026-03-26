import 'dart:developer' show log;
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:dio/dio.dart' show Response;

class EpisodesRepoImpl implements EpisodesRepo {
  EpisodesRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

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
    try {
      final Response<dynamic> response = await networkService.get(
        '${ATEndpoints.shows}$showId/episodes/$episodeId',
      );

      final Episode episodeResponse =
          Episode.fromJson(response.data);
      return Successful<Episode>(data: episodeResponse);
    } catch (e) {
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
}
