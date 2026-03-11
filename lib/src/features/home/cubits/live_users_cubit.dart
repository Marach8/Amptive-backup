import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/response/live_users_response_model.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveUsersCubit extends Cubit<ATAppState<LiveUsersResponseModel>> {
  LiveUsersCubit({HomeRepo? mockHomeRepo})
      : homeRepo = mockHomeRepo ?? HomeRepoImpl(),
        super(const InitialState<LiveUsersResponseModel>());

  final HomeRepo homeRepo;

  LiveUsersResponseModel? get currentLiveUsersData => switch (state) {
        InitialState<LiveUsersResponseModel>(
          :final LiveUsersResponseModel? initialData
        ) =>
          initialData,
        LoadingState<LiveUsersResponseModel>(
          :final LiveUsersResponseModel? currentData
        ) =>
          currentData,
        SuccessState<LiveUsersResponseModel>(
          :final LiveUsersResponseModel? newData
        ) =>
          newData,
        FailureState<LiveUsersResponseModel>(
          :final LiveUsersResponseModel? oldData
        ) =>
          oldData,
      };

  Future<void> fetchLiveUsers() async {
    emit(const LoadingState<LiveUsersResponseModel>());
    try {
      final ApiResponse<LiveUsersResponseModel> response =
          await homeRepo.fetchLiveUsers(
        page: 0,
        pageSize: 20,
        refresh: false,
      );
      response.when(
        successful: (Successful<LiveUsersResponseModel> data) {
          emit(SuccessState<LiveUsersResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<LiveUsersResponseModel> error) {
          emit(FailureState<LiveUsersResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<LiveUsersResponseModel>('Unable to get live shows: $e'));
    }
  }
}
