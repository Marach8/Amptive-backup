import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef StartLiveProgramState = ({
  String? liveProgramId,
  String? starterToken,
});

class StartLiveProgramCubit extends Cubit<ATAppState<StartLiveProgramState>> {
  StartLiveProgramCubit({GoLiveRepo? mockGoLiveRepo})
      : goLiveRepo = mockGoLiveRepo ?? GoLiveRepoImpl(),
        super(const InitialState<StartLiveProgramState>());

  final GoLiveRepo goLiveRepo;

  StartLiveProgramState? get currentData => switch (state) {
    InitialState<StartLiveProgramState>(
      :final StartLiveProgramState? initialData) => initialData,
    LoadingState<StartLiveProgramState>(
      :final StartLiveProgramState? currentData) => currentData,
    SuccessState<StartLiveProgramState>(
      :final StartLiveProgramState? newData) => newData,
    FailureState<StartLiveProgramState>(
      :final StartLiveProgramState? oldData) => oldData,
  };


  Future<void> startLiveProgram({required String contentId}) async {
    emit(LoadingState<StartLiveProgramState>(currentData: currentData));
    try {
      final ApiResponse<StartLiveProgramState> response =
          await goLiveRepo.startLiveProgram(contentId: contentId);
      response.when(
        successful: (Successful<StartLiveProgramState> data) {
          emit(SuccessState<StartLiveProgramState>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<StartLiveProgramState> error) {
          emit(FailureState<StartLiveProgramState>(error.error.message,
              oldData: currentData));
        },
      );
    } catch (e) {
      emit(FailureState<StartLiveProgramState>(
        'Unable to start live program: $e',
          oldData: currentData));
    }
  }
}
