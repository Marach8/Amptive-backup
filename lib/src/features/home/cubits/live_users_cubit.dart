import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/response/live_users_response_model.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveUsersCubit extends Cubit<ATAppState<LiveUsersResponseModel>>
    with SafeEmit<ATAppState<LiveUsersResponseModel>> {
  LiveUsersCubit({HomeRepo? mockHomeRepo})
      : homeRepo = mockHomeRepo ?? HomeRepoImpl(),
        super(const InitialState<LiveUsersResponseModel>());

  final HomeRepo homeRepo;

  LiveUsersResponseModel? get currentLiveUsersData => switch (state) {
        InitialState<LiveUsersResponseModel>(
          :final LiveUsersResponseModel? initialData
        ) => initialData,
        LoadingState<LiveUsersResponseModel>(
          :final LiveUsersResponseModel? currentData
        ) => currentData,
        SuccessState<LiveUsersResponseModel>(
          :final LiveUsersResponseModel? newData
        ) => newData,
        FailureState<LiveUsersResponseModel>(
          :final LiveUsersResponseModel? oldData
        ) => oldData,
      };

  Future<void> fetchLiveUsers() async {
    final bool hasMore = currentLiveUsersData?.hasMore ?? true;

    if(state is LoadingState<LiveUsersResponseModel> || !hasMore) return;

    emit(LoadingState<LiveUsersResponseModel>(currentData: currentLiveUsersData));
    try {
      final ApiResponse<LiveUsersResponseModel> response =
          await homeRepo.fetchLiveUsers(
        page: (currentLiveUsersData?.page ?? 0) + 1,
        pageSize: 20,
        refresh: false,
      );
      response.when(
        successful: (Successful<LiveUsersResponseModel> data) {
          final LiveUsersResponseModel? oldData = currentLiveUsersData;
          final LiveUsersResponseModel? newData = data.data;
          final List<LiveUser> liveUsers = <LiveUser>[
            ...?oldData?.liveUsers, ...?newData?.liveUsers,
          ];

          emit(SuccessState<LiveUsersResponseModel>(
            newData: newData?.copyWith(
              liveUsers: liveUsers,
              page: newData.page,
              pageSize: newData.pageSize,
              total: newData.total,
              totalPages: newData.totalPages,
            ),
          ));
        },
        unSuccessful: (Unsuccessful<LiveUsersResponseModel> error) {
          emit(FailureState<LiveUsersResponseModel>(
            error.error.message,
            oldData: currentLiveUsersData,
          ));
        },
      );
    } catch (e) {
      emit(FailureState<LiveUsersResponseModel>(
        'Unable to get live shows: $e',
        oldData: currentLiveUsersData,
      ));
    }
  }


  Future<void> refreshLiveUsers() async {
    if(state is LoadingState<LiveUsersResponseModel>) return;

    emit(LoadingState<LiveUsersResponseModel>(currentData: currentLiveUsersData));
    try {
      final ApiResponse<LiveUsersResponseModel> response =
          await homeRepo.fetchLiveUsers(
        page: 1,
        pageSize: 20,
        refresh: true,
      );
      response.when(
        successful: (Successful<LiveUsersResponseModel> data) {
          emit(SuccessState<LiveUsersResponseModel>(
            newData: data.data
          ));
        },
        unSuccessful: (Unsuccessful<LiveUsersResponseModel> error) {
          emit(FailureState<LiveUsersResponseModel>(
            error.error.message,
            oldData: currentLiveUsersData,
          ));
        },
      );
    } catch (e) {
      emit(FailureState<LiveUsersResponseModel>(
        'Unable to get live shows: $e',
        oldData: currentLiveUsersData,
      ));
    }
  }
}
