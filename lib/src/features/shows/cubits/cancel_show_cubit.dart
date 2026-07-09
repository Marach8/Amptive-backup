import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelShowCubit extends Cubit<ATAppState<HostedShow>> {
  CancelShowCubit({ShowsRepo? mockShowsRepo})
      : showsRepo = mockShowsRepo ?? ShowsRepoImpl(),
        super(InitialState<HostedShow>());

  final ShowsRepo showsRepo;

  Future<void> cancelShow({required String showId, String reason = 'User requested cancellation'}) async {
    emit(LoadingState<HostedShow>());
    final ApiResponse<HostedShow> response = await showsRepo.cancelShow(
      showId: showId,
      reason: reason,
    );
    if (response is Successful<HostedShow> && response.data != null) {
      emit(SuccessState<HostedShow>(newData: response.data!));
    } else if (response is Unsuccessful<HostedShow>) {
      emit(FailureState<HostedShow>(response.error.message ?? 'Failed to cancel show'));
    } else {
      emit(FailureState<HostedShow>('Failed to cancel show'));
    }
  }
}
