import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReactToLiveProgramCubit extends Cubit<ATAppState<dynamic>> {
  ReactToLiveProgramCubit({GoLiveRepo? mockGoLiveRepo})
      : goLiveRepo = mockGoLiveRepo ?? GoLiveRepoImpl(),
        super(const InitialState<dynamic>());

  final GoLiveRepo goLiveRepo;

  dynamic get currentData => switch (state) {
        InitialState<dynamic>(:final dynamic initialData) => initialData,
        LoadingState<dynamic>(:final dynamic currentData) => currentData,
        SuccessState<dynamic>(:final dynamic newData) => newData,
        FailureState<dynamic>(:final dynamic oldData) => oldData,
      };

  Future<void> reactToLiveProgram({required String livestreamId}) async {
    emit(LoadingState<dynamic>(currentData: currentData));
    try {
      final ApiResponse<dynamic> response =
          await goLiveRepo.reactToLiveProgram(livestreamId: livestreamId);
      response.when(
        successful: (Successful<dynamic> data) {
          emit(SuccessState<dynamic>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<dynamic>(error.error.message,
              oldData: currentData));
        },
      );
    } catch (e) {
      emit(FailureState<dynamic>('Unable to react to live program: $e',
          oldData: currentData));
    }
  }
}
