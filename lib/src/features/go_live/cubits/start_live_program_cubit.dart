import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/cubits/get_live_program_entry_token_cubit.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartLiveProgramCubit extends Cubit<ATAppState<LiveProgramEntryToken>> {
  StartLiveProgramCubit({GoLiveRepo? mockGoLiveRepo})
      : goLiveRepo = mockGoLiveRepo ?? GoLiveRepoImpl(),
        super(const InitialState<LiveProgramEntryToken>());

  final GoLiveRepo goLiveRepo;

  LiveProgramEntryToken? get currentData => switch (state) {
    InitialState<LiveProgramEntryToken>(
      :final LiveProgramEntryToken? initialData) => initialData,
    LoadingState<LiveProgramEntryToken>(
      :final LiveProgramEntryToken? currentData) => currentData,
    SuccessState<LiveProgramEntryToken>(
      :final LiveProgramEntryToken? newData) => newData,
    FailureState<LiveProgramEntryToken>(
      :final LiveProgramEntryToken? oldData) => oldData,
  };


  Future<void> startLiveProgram({required String contentId}) async {
    emit(LoadingState<LiveProgramEntryToken>(currentData: currentData));
    try {
      final ApiResponse<LiveProgramEntryToken> response =
          await goLiveRepo.startLiveProgram(contentId: contentId);
      response.when(
        successful: (Successful<LiveProgramEntryToken> data) async{
          emit(SuccessState<LiveProgramEntryToken>(newData: data.data));

          // final String? token = data.data?.roomEntryToken;
          // if(token == null){
          //   final ApiResponse<LiveProgramEntryToken> fooResponse = 
          //   await goLiveRepo.getLiveProgramEntryToken(
          //     livestreamId: data.data?.streamId ?? '');
          //   fooResponse.when(
          //     successful: (Successful<LiveProgramEntryToken> fooData){
          //       emit(SuccessState<LiveProgramEntryToken>(newData: fooData.data));
          //     },
          //     unSuccessful: (Unsuccessful<LiveProgramEntryToken> fooError){
          //       emit(FailureState<LiveProgramEntryToken>(fooError.error.message,
          //           oldData: currentData));
          //     },
          //   );
          // }
          // else {
          //   emit(SuccessState<LiveProgramEntryToken>(newData: data.data));
          // }
        },
        unSuccessful: (Unsuccessful<LiveProgramEntryToken> error) {
          emit(FailureState<LiveProgramEntryToken>(error.error.message,
              oldData: currentData));
        },
      );
    } catch (e) {
      emit(FailureState<LiveProgramEntryToken>(
        'Unable to start live program: $e',
          oldData: currentData));
    }
  }
}
