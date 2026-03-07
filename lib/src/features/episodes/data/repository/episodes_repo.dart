import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/create_episode_response_model.dart';

abstract class EpisodesRepo {
  Future<ApiResponse<CreateEpisodeResponseModel>> createEpisode({
    required String showId,
    required CreateEpisodeRequestModel episodeData,
  });
}
