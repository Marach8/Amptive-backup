import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveProgramEntryToken {
  const LiveProgramEntryToken({
    this.roomEntryToken,
    this.roomUrl,
    this.streamId,
    this.roomParticipantId,
    this.allowHandRaise,
    this.allowWhispers,
    this.allowAudienceMic,
    this.allowComments,
  });

  final String? roomEntryToken,
    roomUrl, streamId, roomParticipantId;
  final bool? allowHandRaise, allowWhispers,
    allowAudienceMic, allowComments;
}


class GetLiveProgramEntryTokenCubit extends 
  Cubit<ATAppState<LiveProgramEntryToken>> {
  GetLiveProgramEntryTokenCubit({GoLiveRepo? mockGoLiveRepo})
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

  Future<void> getLiveProgramEntryToken(String livestreamId) async {
    emit(LoadingState<LiveProgramEntryToken>(currentData: currentData));
    try {
      final ApiResponse<LiveProgramEntryToken> response =
          await goLiveRepo.getLiveProgramEntryToken(
            livestreamId: livestreamId);
      response.when(
        successful: (Successful<LiveProgramEntryToken> data) {
          emit(SuccessState<LiveProgramEntryToken>(
            newData: data.data));
        },
        unSuccessful: (Unsuccessful<LiveProgramEntryToken> error) {
          emit(FailureState<LiveProgramEntryToken>(
            error.error.message,
            oldData: currentData));
        },
      );
    } catch (e) {
      emit(FailureState<LiveProgramEntryToken>(
        'Unable to get live program entry token: $e',
          oldData: currentData));
    }
  }
}
