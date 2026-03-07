import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/create_episode_response_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for creating a new episode
class CreateEpisodeCubit extends Cubit<ATAppState<CreateEpisodeResponseModel>> {
  CreateEpisodeCubit({EpisodesRepo? mockEpisodesRepo})
      : episodesRepo = mockEpisodesRepo ?? EpisodesRepoImpl(),
        super(const InitialState<CreateEpisodeResponseModel>());

  final EpisodesRepo episodesRepo;

  Future<void> createEpisode({
    required String showId,
    required CreateEpisodeRequestModel episodeData,
  }) async {
    emit(const LoadingState<CreateEpisodeResponseModel>());
    try {
      final ApiResponse<CreateEpisodeResponseModel> response =
          await episodesRepo.createEpisode(
        showId: showId,
        episodeData: episodeData,
      );

      response.when(
        successful: (Successful<CreateEpisodeResponseModel> data) {
          emit(SuccessState<CreateEpisodeResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<CreateEpisodeResponseModel> error) {
          emit(FailureState<CreateEpisodeResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<CreateEpisodeResponseModel>(
          'Unable to create episode: $e'));
    }
  }
}
