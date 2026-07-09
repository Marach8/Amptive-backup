import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo_impl.dart';

class ShowDetailCubit extends Cubit<ATAppState<HostedShow>> {
  ShowDetailCubit({
    ShowsRepo? mockShowsRepo,
    required HostedShow initialShow,
  })  : showsRepo = mockShowsRepo ?? ShowsRepoImpl(),
        super(InitialState<HostedShow>(initialData: initialShow));

  final ShowsRepo showsRepo;

  HostedShow? get currentShowDetail => switch (state) {
    InitialState<HostedShow>(:final HostedShow? initialData) => initialData,
    LoadingState<HostedShow>(:final HostedShow? currentData) => currentData,
    SuccessState<HostedShow>(:final HostedShow? newData) => newData,
    FailureState<HostedShow>(:final HostedShow? oldData) => oldData,
  };

  Future<void> fetchShowDetails() async {
    final String showId = currentShowDetail?.showId ?? '';
    
    final HostedShow? cachedShow = ShowsRepoImpl.getCachedShow(showId);
    if (cachedShow != null) {
      emit(SuccessState<HostedShow>(newData: cachedShow));
      return;
    }

    if (state is LoadingState<HostedShow>) return;
    emit(LoadingState<HostedShow>(currentData: currentShowDetail));
    try {
      final ApiResponse<HostedShow> response =
          await showsRepo.fetchShow(showId: currentShowDetail?.showId ?? '');
      response.when(
        successful: (Successful<HostedShow> data) {
          emit(SuccessState<HostedShow>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HostedShow> error) {
          emit(
            FailureState<HostedShow>(
              error.error.message,
              oldData: currentShowDetail,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<HostedShow>(
          'Unable to fetch show: $e',
          oldData: currentShowDetail,
        ),
      );
    }
  }


  void updateAnEpisode(Episode episode) {
    final String? idOfEpisode = episode.episodeId;
    final List<Episode>? episodes = currentShowDetail?.episodes;
    if (idOfEpisode == null || episodes == null) return;

    final int episodeIndex = episodes.indexWhere(
      (Episode element) => element.episodeId == idOfEpisode);
    if (episodeIndex == -1) return;    
    episodes[episodeIndex] = episode;

    final HostedShow? newData = currentShowDetail
      ?.copyEpisodes(episodes);
    emit(SuccessState<HostedShow>(newData: newData));
  }
  void updateShowLocally(HostedShow updatedShow) {
    emit(SuccessState<HostedShow>(newData: updatedShow));
  }
}
