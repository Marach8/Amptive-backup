import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CreateEpisodeCubit extends Cubit<ATAppState<Episode>> {
  CreateEpisodeCubit({EpisodesRepo? mockEpisodesRepo})
      : episodesRepo = mockEpisodesRepo ?? EpisodesRepoImpl(),
        super(const InitialState<Episode>());

  final EpisodesRepo episodesRepo;

  Future<void> createEpisode({
    required String showId,
    required CreateEpisodePayload episodeData,
  }) async {
    emit(const LoadingState<Episode>());
    try {
      final ApiResponse<Episode> response =
          await episodesRepo.createEpisode(
        showId: showId,
        episodeData: episodeData,
      );

      response.when(
        successful: (Successful<Episode> data) {
          emit(SuccessState<Episode>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<Episode> error) {
          emit(FailureState<Episode>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<Episode>(
          'Unable to create episode: $e'));
    }
  }
}
