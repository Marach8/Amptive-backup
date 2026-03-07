import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/get_all_users_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUsersCubit extends Cubit<ATAppState<AllUsersResponseModel>> {
  AllUsersCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<AllUsersResponseModel>());

  final DiscoverRepo discoverRepo;
  List<User> _cachedUsers = <User>[];

  AllUsersResponseModel? get currentUsersData => switch (state) {
    InitialState<AllUsersResponseModel>(:final AllUsersResponseModel? initialData) => initialData,
    LoadingState<AllUsersResponseModel>(:final AllUsersResponseModel? currentData) => currentData,
    SuccessState<AllUsersResponseModel>(:final AllUsersResponseModel? newData) => newData,
    FailureState<AllUsersResponseModel>(:final AllUsersResponseModel? oldData) => oldData,
  };

  Future<void> fetchAllUsers() async {
    final bool hasMore = currentUsersData?.hasMore ?? true;
    if(state is LoadingState<AllUsersResponseModel> || !hasMore){
      return;
    }

    emit(LoadingState<AllUsersResponseModel>(
      currentData: currentUsersData));
    
    try {
      final ApiResponse<AllUsersResponseModel> response =
          await discoverRepo.fetchAllUsers(
        page: (currentUsersData?.page ?? -1) + 1,
        pageSize: 50
      );
      response.when(
        successful: (Successful<AllUsersResponseModel> data) {
          _cachedUsers = data.data?.data ?? <User>[];
          emit(SuccessState<AllUsersResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<AllUsersResponseModel> error) {
          emit(FailureState<AllUsersResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<AllUsersResponseModel>(
          'Unable to get users: $e'));
    }
  }

  Future<void> searchUsers(String query) async {
    final List<User> allUsers = currentUsersData?.data ?? <User>[];
    if(allUsers.isEmpty){return;}

    if (query.isEmpty) {
      emit(SuccessState<AllUsersResponseModel>(
        newData: currentUsersData?.copyWith(
          data: _cachedUsers,
        ),
      ));
      return;
    }

    emit(LoadingState<AllUsersResponseModel>(currentData: currentUsersData));

    final List<User> filteredUsers = allUsers
        .where((User user) => (user.username
          ?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (user.name
          ?.toLowerCase().contains(query.toLowerCase()) ?? false)
        ).toList();

    if(filteredUsers.isEmpty){
      emit(
        FailureState<AllUsersResponseModel>(
          'No users found matching "$query".',
          oldData: currentUsersData,
        ),
      );
      return;
    }

    final AllUsersResponseModel? filteredData = currentUsersData?.copyWith(
      data: filteredUsers,
    );

    emit(SuccessState<AllUsersResponseModel>(newData: filteredData));
  }


  void resetSearch() => emit(SuccessState<AllUsersResponseModel>(
    newData: currentUsersData?.copyWith(
      data: _cachedUsers,
    ),
  ));
}
