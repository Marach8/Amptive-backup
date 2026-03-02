import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ToggleFollowingCubit extends Cubit<ATAppState<FollowingStatus>> {
  ToggleFollowingCubit({
    HomeRepo? mockHomeRepo,
    required FollowingStatus initialStatus,
  }) : homeRepo = mockHomeRepo ?? HomeRepoImpl(),
      super(InitialState<FollowingStatus>(initialData: initialStatus));

  final HomeRepo homeRepo;

  FollowingStatus? get currentFollowStatus => switch (state) {
    InitialState<FollowingStatus>(:final FollowingStatus? initialData) => initialData,
    LoadingState<FollowingStatus>(:final FollowingStatus? currentData) => currentData,
    SuccessState<FollowingStatus>(:final FollowingStatus? newData) => newData,
    FailureState<FollowingStatus>(:final FollowingStatus? oldData) => oldData,
  };

  //This represents the initial follow status just before the first tap to toggle.
  FollowingStatus? _firstInitialFollowStatus;
  bool _didExecuteDebouncedToggle = false;
  String? _cachedTargetUserId;

  Future<void> toggleIsFollowing({required String targetUserId}) async {
    _cachedTargetUserId = targetUserId;
    _didExecuteDebouncedToggle = false;

    final bool isCurrentlyFollowing = currentFollowStatus?.isFollowing ?? false;
    final int currentFollowersCount = currentFollowStatus?.followerCount ?? 0;

    final FollowingStatus? expectedFollowStatus = currentFollowStatus?.copyWith(
      isFollowing: !isCurrentlyFollowing,
      followerCount: isCurrentlyFollowing
        ? (currentFollowersCount > 0 ? currentFollowersCount - 1 : 0)
        : currentFollowersCount + 1,
    );

    _firstInitialFollowStatus ??= currentFollowStatus;

    emit(LoadingState<FollowingStatus>(currentData: expectedFollowStatus));

    ATHelperFuncs.callDebouncer(
      3000,
      _executeDebouncedToggle,
      <String>[targetUserId],
    );
  }


  @override
  Future<void> close() {
    if(!_didExecuteDebouncedToggle && _cachedTargetUserId != null){
      _executeDebouncedToggle(_cachedTargetUserId!);
    }
    ATHelperFuncs.disposeDebouncer();
    return super.close();
  }


  Future<void> _executeDebouncedToggle(String targetUserId) async {
    _didExecuteDebouncedToggle = true;

    final FollowingStatus? initialFollowStatus =
      _firstInitialFollowStatus ?? currentFollowStatus;

    _firstInitialFollowStatus = null;

    if (currentFollowStatus == initialFollowStatus) {
      return;
    }

    try {
      late ApiResponse<FollowingStatus> response;

      if (initialFollowStatus?.isFollowing == true) {
        response = await homeRepo.unFollowTargetUser(targetUserId: targetUserId);
      } else {
        response = await homeRepo.followTargetUser(targetUserId: targetUserId);
      }

      //Do not emit a state if this cubit is disposed.
      if (isClosed) return;

      response.when(
        successful: (Successful<FollowingStatus> data) {
          emit(SuccessState<FollowingStatus>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<FollowingStatus> error) {
          emit(FailureState<FollowingStatus>(
            error.error.message,
            oldData: initialFollowStatus,
          ));
        },
      );
    } catch (_) {}
  }
}
