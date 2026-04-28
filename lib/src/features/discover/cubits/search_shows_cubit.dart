import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/search_shows_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchShowsCubit extends Cubit<ATAppState<SearchShowsResponseModel>> {
  SearchShowsCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<SearchShowsResponseModel>());

  final DiscoverRepo discoverRepo;

  SearchShowsResponseModel? get currentSearchData => switch (state) {
    InitialState<SearchShowsResponseModel>(:final SearchShowsResponseModel? initialData) => initialData,
    LoadingState<SearchShowsResponseModel>(:final SearchShowsResponseModel? currentData) => currentData,
    SuccessState<SearchShowsResponseModel>(:final SearchShowsResponseModel? newData) => newData,
    FailureState<SearchShowsResponseModel>(:final SearchShowsResponseModel? oldData) => oldData,
  };

  Future<void> searchShows(String query) async {
    if (query.isEmpty) {
      emit(const InitialState<SearchShowsResponseModel>());
      return;
    }
    
    emit(const LoadingState<SearchShowsResponseModel>());

    try {
      final ApiResponse<SearchShowsResponseModel> response =
          await discoverRepo.searchShows(
        query: query,
        page: 1,
        pageSize: 100,
        sortBy: 'relevance',
        category: null,
        status: null,
        showType: null,
        hostId: null,

      );
      
      response.when(
        successful: (Successful<SearchShowsResponseModel> data) {
          emit(SuccessState<SearchShowsResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<SearchShowsResponseModel> error) {
          emit(FailureState<SearchShowsResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<SearchShowsResponseModel>('Search failed: $e'));
    }
  }
}
