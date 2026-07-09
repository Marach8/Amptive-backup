import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';

class EpisodeDetailCubit extends Cubit<ATAppState<Episode>> {
  EpisodeDetailCubit({
    EpisodesRepo? mockEpisodesRepo,
    required Episode initialEpisode,
  })  : episodesRepo = mockEpisodesRepo ?? EpisodesRepoImpl(),
        super(InitialState<Episode>(initialData: initialEpisode));

  final EpisodesRepo episodesRepo;

  Episode? get currentEpisodeDetail => switch (state) {
    InitialState<Episode>(:final Episode? initialData) => initialData,
    LoadingState<Episode>(:final Episode? currentData) => currentData,
    SuccessState<Episode>(:final Episode? newData) => newData,
    FailureState<Episode>(:final Episode? oldData) => oldData,
  };

  Future<void> fetchEpisodeDetails() async {
    final String episodeId = currentEpisodeDetail?.episodeId ?? '';
    final String showId = currentEpisodeDetail?.showId ?? '';

    // Without both ids the detail endpoint can't be built (it would 404 on
    // `shows//episodes/<id>`). Keep the already-seeded data instead.
    if (episodeId.isEmpty || showId.isEmpty) return;

    final Episode? cachedEpisode = EpisodesRepoImpl.getCachedEpisode(episodeId);
    if (cachedEpisode != null) {
      emit(SuccessState<Episode>(newData: cachedEpisode.copyWith(parentShowTitle: currentEpisodeDetail?.parentShowTitle)));
      return;
    }

    if (state is LoadingState<Episode>) return;
    emit(LoadingState<Episode>(currentData: currentEpisodeDetail));
    try {
      final ApiResponse<Episode> response =
          await episodesRepo.fetchEpisodeDetail(
        showId: currentEpisodeDetail?.showId ?? '',
        episodeId: currentEpisodeDetail?.episodeId ?? '',
      );

      response.when(
        successful: (Successful<Episode> data) {
          emit(SuccessState<Episode>(
            newData: data.data?.copyWith(
              parentShowTitle: currentEpisodeDetail?.parentShowTitle)
          ));
        },
        unSuccessful: (Unsuccessful<Episode> error) {
          emit(
            FailureState<Episode>(
              error.error.message,
              oldData: currentEpisodeDetail,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<Episode>(
          'Unable to fetch episode: $e',
          oldData: currentEpisodeDetail,
        ),
      );
    }
  }


  void updateEpisode(Episode newEpisode){
    emit(SuccessState<Episode>(newData: newEpisode));
  }
}
