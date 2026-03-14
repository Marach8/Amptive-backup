import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/empty.dart';
import 'package:amptive/src/shared/global_model_objects.dart' show Episode;

abstract class EpisodesRepo {
  Future<ApiResponse<Episode>> createEpisode({
    required String showId,
    required CreateEpisodePayload episodeData,
  });
}
