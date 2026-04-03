import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episodes_response_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodesOfAShowCubit extends Cubit<ATAppState<EpisodesResponseModel>> {
  EpisodesOfAShowCubit({
    required this.showId,
    EpisodesRepo? mockEpisodesRepo
  }) : episodesRepo = mockEpisodesRepo ?? EpisodesRepoImpl(),
        super(const InitialState<EpisodesResponseModel>());

  final EpisodesRepo episodesRepo;
  final String showId;

  EpisodesResponseModel? get currentEpisodesData => switch (state) {
        InitialState<EpisodesResponseModel>(
          :final EpisodesResponseModel? initialData
        ) =>
          initialData,
        LoadingState<EpisodesResponseModel>(
          :final EpisodesResponseModel? currentData
        ) =>
          currentData,
        SuccessState<EpisodesResponseModel>(
          :final EpisodesResponseModel? newData
        ) =>
          newData,
        FailureState<EpisodesResponseModel>(
          :final EpisodesResponseModel? oldData
        ) =>
          oldData,
      };

  Future<void> fetchEpisodesOfAShow() async {
    final bool hasMore = currentEpisodesData?.hasMore ?? true;
    if (state is LoadingState<EpisodesResponseModel> || !hasMore) {
      return;
    }

    emit(LoadingState<EpisodesResponseModel>(
        currentData: currentEpisodesData));
    try {
      final ApiResponse<EpisodesResponseModel> response = await episodesRepo
        .fetchEpisodesOfAShow(
        showId: showId,
        page: (currentEpisodesData?.page ?? 0) + 1,
        pageSize: 20,
        status: '',
      );
      response.when(
        successful: (Successful<EpisodesResponseModel> data) {
          final List<Episode>? newEpisodes = data.data?.episodes;
          final List<Episode> mergedEpisodes = <Episode>[
            ...?currentEpisodesData?.episodes,
            ...?newEpisodes,
          ];

          final EpisodesResponseModel newData = EpisodesResponseModel(
            episodes: mergedEpisodes,
            total: data.data?.total,
            page: data.data?.page,
            pageSize: data.data?.pageSize,
          );
          emit(SuccessState<EpisodesResponseModel>(newData: newData));
        },
        unSuccessful: (Unsuccessful<EpisodesResponseModel> error) {
          emit(FailureState<EpisodesResponseModel>(error.error.message,
              oldData: currentEpisodesData));
        },
      );
    } catch (e) {
      emit(FailureState<EpisodesResponseModel>('Unable to fetch episodes: $e',
          oldData: currentEpisodesData));
    }
  }
}
