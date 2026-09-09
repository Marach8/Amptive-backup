import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/response/whispers_response_model.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveWhispersCubit extends Cubit<ATAppState<List<Whisper>>> {
  LiveWhispersCubit({HomeRepo? mockHomeRepo})
      : homeRepo = mockHomeRepo ?? HomeRepoImpl(),
        super(const InitialState<List<Whisper>>());

  final HomeRepo homeRepo;

  Future<void> fetchWhispers({
    required String livestreamId,
    int? limit,
    String? beforeId,
  }) async {
    emit(const LoadingState<List<Whisper>>());

    try {
      final ApiResponse<WhispersResponseModel> response = 
      await homeRepo.fetchWhispers(
        livestreamId: livestreamId,
        limit: limit,
        beforeId: beforeId,
      );

      await response.when(
        successful: (Successful<WhispersResponseModel> data) {
          if(isClosed) return;
          emit(
            SuccessState<List<Whisper>>(
              newData: data.data?.data?.whispers
            ),
          );
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          if(isClosed) return;
          emit(
            FailureState<List<Whisper>>(
              error.error.message,
            ),
          );
        },
      );
    } catch (_) {
      if(isClosed) return;
      emit(const FailureState<List<Whisper>>(
        'Unable to get chat:'));
    }
  }
}
