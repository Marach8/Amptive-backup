import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodesOfAShowCubit extends Cubit<ATAppState<dynamic>> {
  EpisodesOfAShowCubit({
    required this.showId,
    EpisodesRepo? mockEpisodesRepo
  }) : episodesRepo = mockEpisodesRepo ?? EpisodesRepoImpl(),
        super(const InitialState<dynamic>());

  final EpisodesRepo episodesRepo;
  final String showId;

  Future<void> fetchEpisodesOfAShow() async {
    emit(const LoadingState<dynamic>());
    try {
      final ApiResponse<dynamic> response = await episodesRepo
        .fetchEpisodesOfAShow(
        showId: showId,
        page: 1,
        pageSize: 20,
        status: '',
      );
      response.when(
        successful: (Successful<dynamic> data) {
          emit(SuccessState<dynamic>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<dynamic>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<dynamic>('Unable to fetch episodes: $e'));
    }
  }
}
