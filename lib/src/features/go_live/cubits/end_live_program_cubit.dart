import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


enum LoadingStage {
  initial,
  showListeners,
  showGifts,
  finished,
}

class EndLiveProgramCubit
    extends Cubit<ATAppState<LoadingStage>> {

  EndLiveProgramCubit({
    GoLiveRepo? mockGoLiveRepo,
  })  : goLiveRepo = mockGoLiveRepo ?? GoLiveRepoImpl(),
        super(
          const InitialState<LoadingStage>(),
        );

  final GoLiveRepo goLiveRepo;

  LoadingStage? get currentStage => switch (state) {
    InitialState<LoadingStage>(
      :final LoadingStage? initialData) => initialData,
    LoadingState<LoadingStage>(
      :final LoadingStage? currentData) => currentData,
    SuccessState<LoadingStage>(
      :final LoadingStage? newData) => newData,
    FailureState<LoadingStage>(
      :final LoadingStage? oldData) => oldData,
  };

  Future<void> endLiveProgram(String livestreamId)async {
    emit(
      const LoadingState<LoadingStage>(currentData: LoadingStage.initial),
    );

    try {
      final Future<ApiResponse<bool>> apiFuture =
          goLiveRepo.endLiveProgram(livestreamId: livestreamId);

      final Future<void> animationFuture = _runEndingSequence();
      
      final (ApiResponse<bool> response, void) results = 
        await (apiFuture, animationFuture).wait;

      final ApiResponse<bool> response = results.$1;

      response.when(
        successful: (_) {
          emit(
            const SuccessState<LoadingStage>(
              newData: LoadingStage.finished,
            ),
          );
        },
        unSuccessful: (Unsuccessful<bool> error) {
          emit(
            FailureState<LoadingStage>(
              error.error.message,
              oldData: LoadingStage.finished,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<LoadingStage>(
          'Unable to end live program: $e',
          oldData: LoadingStage.finished,
        ),
      );
    }
  }



  Future<void> _runEndingSequence() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    emit(
      const LoadingState<LoadingStage>(
        currentData: LoadingStage.showListeners,
      ),
    );

    await Future<void>.delayed(
      const Duration(milliseconds: 800),
    );

    emit(
      const LoadingState<LoadingStage>(
        currentData: LoadingStage.showGifts,
      ),
    );
  }
}
