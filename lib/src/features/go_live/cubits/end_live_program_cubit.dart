import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EndLiveProgramCubit extends Cubit<ATAppState<bool>> {
  EndLiveProgramCubit({GoLiveRepo? mockGoLiveRepo})
      : goLiveRepo = mockGoLiveRepo ?? GoLiveRepoImpl(),
        super(const InitialState<bool>());

  final GoLiveRepo goLiveRepo;

  bool? get currentData => switch (state) {
    InitialState<bool>(:final bool? initialData) => initialData,
    LoadingState<bool>(:final bool? currentData) => currentData,
    SuccessState<bool>(:final bool? newData) => newData,
    FailureState<bool>(:final bool? oldData) => oldData,
  };

  Future<void> endLiveProgram(String livestreamId) async {
    emit(LoadingState<bool>(currentData: currentData));
    try {
      final ApiResponse<bool> response =
          await goLiveRepo.endLiveProgram(livestreamId: livestreamId);
      response.when(
        successful: (Successful<bool> data) {
          emit(SuccessState<bool>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<bool> error) {
          emit(FailureState<bool>(error.error.message,
              oldData: currentData));
        },
      );
    } catch (e) {
      emit(FailureState<bool>('Unable to end live program: $e',
          oldData: currentData));
    }
  }
}
