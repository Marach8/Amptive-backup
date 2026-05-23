import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/response/going_status.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoingCubit extends Cubit<ATAppState<GoingStatus>> {
  GoingCubit({
    HomeRepo? mockHomeRepo,
    required GoingStatus initialStatus,
  })  : homeRepo = mockHomeRepo ?? HomeRepoImpl(),
        super(InitialState<GoingStatus>(initialData: initialStatus));

  final HomeRepo homeRepo;

  GoingStatus? get currentGoingStatus => switch (state) {
        InitialState<GoingStatus>(:final GoingStatus? initialData) =>
          initialData,
        LoadingState<GoingStatus>(:final GoingStatus? currentData) =>
          currentData,
        SuccessState<GoingStatus>(:final GoingStatus? newData) => newData,
        FailureState<GoingStatus>(:final GoingStatus? oldData) => oldData,
      };

  GoingStatus? _initialStatus;
  bool _didToggle = false;

  Future<void> toggleGoing({
    required String contentId,
    required GoingType type,
  }) async {
    if (_didToggle) return;
    _didToggle = true;

    _initialStatus ??= currentGoingStatus;

    final bool isCurrentlyGoing = currentGoingStatus?.isGoing ?? false;
    final int currentCount = currentGoingStatus?.goingCount ?? 0;

    final GoingStatus? expectedStatus = GoingStatus(
      isGoing: !isCurrentlyGoing,
      goingCount: isCurrentlyGoing
          ? (currentCount > 0 ? currentCount - 1 : 0)
          : currentCount + 1,
    );

    emit(LoadingState<GoingStatus>(currentData: expectedStatus));

    try {
      late ApiResponse<GoingStatus> response;

      if (isCurrentlyGoing) {
        response = await homeRepo.unmarkGoing(
          contentId: contentId,
          type: type,
        );
      } else {
        response = await homeRepo.markAsGoing(
          contentId: contentId,
          type: type,
        );
      }

      if (isClosed) return;

      response.when(
        successful: (Successful<GoingStatus> data) {
          emit(SuccessState<GoingStatus>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<GoingStatus> error) {
          emit(FailureState<GoingStatus>(
            error.error.message,
            oldData: _initialStatus,
          ));
        },
      );
    } catch (_) {}
  }
}
