import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef EndLiveProgramState = ({
  int? totalGifts,
  int? totalListeners,
  bool? didEnd
});

enum EndingStage{initial, showListeners, showGifts, failed}

class EndLiveProgramCubit extends Cubit<ATAppState<EndLiveProgramState>> {
  EndLiveProgramCubit({GoLiveRepo? mockGoLiveRepo})
      : goLiveRepo = mockGoLiveRepo ?? GoLiveRepoImpl(),
        super(const InitialState<EndLiveProgramState>());

  final GoLiveRepo goLiveRepo;

  EndLiveProgramState? get currentData => switch (state) {
    InitialState<EndLiveProgramState>(:final EndLiveProgramState? initialData) => initialData,
    LoadingState<EndLiveProgramState>(:final EndLiveProgramState? currentData) => currentData,
    SuccessState<EndLiveProgramState>(:final EndLiveProgramState? newData) => newData,
    FailureState<EndLiveProgramState>(:final EndLiveProgramState? oldData) => oldData,
  };

  Future<void> endLiveProgram(String livestreamId) async {
    emit(LoadingState<EndLiveProgramState>(currentData: currentData));
    try {
      final ApiResponse<bool> response =
          await goLiveRepo.endLiveProgram(livestreamId: livestreamId);
      response.when(
        successful: (Successful<bool> data) {
          emit(SuccessState<EndLiveProgramState>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<bool> error) {
          emit(FailureState<EndLiveProgramState>(error.error.message,
              oldData: currentData));
        },
      );
    } catch (e) {
      emit(FailureState<EndLiveProgramState>('Unable to end live program: $e',
          oldData: currentData));
    }
  }
}
