import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episodes_response_model.dart';

abstract class EpisodesRepo {
  Future<ApiResponse<Episode>> createEpisode({
    required String showId,
    required CreateEpisodePayload episodeData,
  });

  Future<ApiResponse<Episode>> fetchEpisodeDetail({
    required String showId,
    required String episodeId,
  });

  Future<ApiResponse<Episode>> startEpisode({
    required String showId,
    required String episodeId,
    required String streamUrl,
    required String streamKey,
    required String reason,
  });

  Future<ApiResponse<Episode>> updateEpisode({
    required String showId,
    required String episodeId,
    required CreateEpisodePayload episodeData,
  });

  Future<ApiResponse<EpisodesResponseModel>> fetchEpisodesOfAShow({
    required String showId,
    required int page,
    required int pageSize,
    required String status,
  });
}
