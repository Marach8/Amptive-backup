import 'dart:developer' show log;
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/create_episode_response_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:dio/dio.dart' show Response;

class EpisodesRepoImpl implements EpisodesRepo {
  EpisodesRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<CreateEpisodeResponseModel>> createEpisode({
    required String showId,
    required CreateEpisodeRequestModel episodeData,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        '${ATEndpoints.shows}$showId/episodes',
        data: episodeData.toJson(),
      );

      final CreateEpisodeResponseModel episodeResponse =
          CreateEpisodeResponseModel.fromJson(response.data);
      return Successful<CreateEpisodeResponseModel>(data: episodeResponse);
    } catch (e) {
      log('Create episode error: $e');
      return Unsuccessful<CreateEpisodeResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }
}
