import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/get_all_users_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetUsersCubit extends Cubit<ATAppState<GetAllUsersResponseModel>> {
  GetUsersCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<GetAllUsersResponseModel>());

  final DiscoverRepo discoverRepo;

  GetAllUsersResponseModel? get currentUsersData => switch (state) {
    InitialState<GetAllUsersResponseModel>(:final GetAllUsersResponseModel? initialData) => initialData,
    LoadingState<GetAllUsersResponseModel>(:final GetAllUsersResponseModel? currentData) => currentData,
    SuccessState<GetAllUsersResponseModel>(:final GetAllUsersResponseModel? newData) => newData,
    FailureState<GetAllUsersResponseModel>(:final GetAllUsersResponseModel? oldData) => oldData,
  };

  Future<void> fetchAllUsers() async {
    final bool hasMore = currentUsersData?.hasMore ?? true;
    if(state is LoadingState<GetAllUsersResponseModel> || !hasMore){
      return;
    }

    emit(LoadingState<GetAllUsersResponseModel>(
      currentData: currentUsersData));
    
    try {
      final ApiResponse<GetAllUsersResponseModel> response =
          await discoverRepo.fetchAllUsers(
        page: (currentUsersData?.page ?? -1) + 1,
        pageSize: 50
      );
      response.when(
        successful: (Successful<GetAllUsersResponseModel> data) {
          emit(SuccessState<GetAllUsersResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<GetAllUsersResponseModel> error) {
          emit(FailureState<GetAllUsersResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<GetAllUsersResponseModel>(
          'Unable to get users: $e'));
    }
  }
}
