import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/search_users_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUsersCubit extends Cubit<ATAppState<SearchUsersResponseModel>> {
  SearchUsersCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<SearchUsersResponseModel>());

  final DiscoverRepo discoverRepo;

  SearchUsersResponseModel? get currentSearchData => switch (state) {
    InitialState<SearchUsersResponseModel>(:final SearchUsersResponseModel? initialData) => initialData,
    LoadingState<SearchUsersResponseModel>(:final SearchUsersResponseModel? currentData) => currentData,
    SuccessState<SearchUsersResponseModel>(:final SearchUsersResponseModel? newData) => newData,
    FailureState<SearchUsersResponseModel>(:final SearchUsersResponseModel? oldData) => oldData,
  };



  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(const InitialState<SearchUsersResponseModel>());
      return;
    }
    
    emit(const LoadingState<SearchUsersResponseModel>());

    try {
      final ApiResponse<SearchUsersResponseModel> response =
          await discoverRepo.searchUsers(
        query: query,
        page: 1,
        pageSize: 50,
        sortBy: 'relevance',
      );
      
      response.when(
        successful: (Successful<SearchUsersResponseModel> data) {
          emit(SuccessState<SearchUsersResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<SearchUsersResponseModel> error) {
          emit(FailureState<SearchUsersResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<SearchUsersResponseModel>('Search failed: $e'));
    }
  }
}
