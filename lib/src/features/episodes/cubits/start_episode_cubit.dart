import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartEpisodeCubit extends Cubit<ATAppState<Episode>> {
  StartEpisodeCubit({EpisodesRepo? mockEpisodesRepo})
      : episodesRepo = mockEpisodesRepo ?? EpisodesRepoImpl(),
        super(const InitialState<Episode>());

  final EpisodesRepo episodesRepo;

  Episode? get currentEpisodeData => switch (state) {
        InitialState<Episode>(:final Episode? initialData) => initialData,
        LoadingState<Episode>(:final Episode? currentData) => currentData,
        SuccessState<Episode>(:final Episode? newData) => newData,
        FailureState<Episode>(:final Episode? oldData) => oldData,
      };

  Future<void> startEpisode({
    required String showId,
    required String episodeId,
    required String streamUrl,
    required String streamKey,
    required String reason,
  }) async {
    emit(LoadingState<Episode>(currentData: currentEpisodeData));
    try {
      final ApiResponse<Episode> response = await episodesRepo.startEpisode(
        showId: showId,
        episodeId: episodeId,
        streamUrl: streamUrl,
        streamKey: streamKey,
        reason: reason,
      );
      response.when(
        successful: (Successful<Episode> data) {
          emit(SuccessState<Episode>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<Episode> error) {
          emit(FailureState<Episode>(error.error.message,
              oldData: currentEpisodeData));
        },
      );
    } catch (e) {
      emit(FailureState<Episode>('Unable to start episode: $e',
          oldData: currentEpisodeData));
    }
  }
}
