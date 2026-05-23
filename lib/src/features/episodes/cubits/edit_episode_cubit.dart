import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEpisodeCubit extends Cubit<ATAppState<Episode>> {
  EditEpisodeCubit({EpisodesRepo? mockEpisodesRepo})
      : episodesRepo = mockEpisodesRepo ?? EpisodesRepoImpl(),
        super(const InitialState<Episode>());

  Episode? get currentEpisodeDetail => switch (state) {
    InitialState<Episode>(:final Episode? initialData) => initialData,
    LoadingState<Episode>(:final Episode? currentData) => currentData,
    SuccessState<Episode>(:final Episode? newData) => newData,
    FailureState<Episode>(:final Episode? oldData) => oldData,
  };

  final EpisodesRepo episodesRepo;

  Future<void> editEpisode({
    required String showId,
    required String episodeId,
    required CreateEpisodePayload createEpisodeModel,
  }) async {
    emit(const LoadingState<Episode>());
    try {
      final ApiResponse<Episode> response = 
      await episodesRepo.updateEpisode(
        showId: showId,
        episodeId: episodeId,
        episodeData: createEpisodeModel,
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
      emit(FailureState<Episode>('Unable to update episode: $e'));
    }
  }
}
