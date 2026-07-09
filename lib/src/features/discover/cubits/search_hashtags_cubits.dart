import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/search_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchHashtagsCubit extends Cubit<ATAppState<SearchHashtagsResponseModel>>
    with SafeEmit<ATAppState<SearchHashtagsResponseModel>> {
  SearchHashtagsCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<SearchHashtagsResponseModel>());

  final DiscoverRepo discoverRepo;

  SearchHashtagsResponseModel? get currentSearchData => switch (state) {
    InitialState<SearchHashtagsResponseModel>(:final SearchHashtagsResponseModel? initialData) => initialData,
    LoadingState<SearchHashtagsResponseModel>(:final SearchHashtagsResponseModel? currentData) => currentData,
    SuccessState<SearchHashtagsResponseModel>(:final SearchHashtagsResponseModel? newData) => newData,
    FailureState<SearchHashtagsResponseModel>(:final SearchHashtagsResponseModel? oldData) => oldData,
  };

  Future<void> searchHashtags(String query) async {
    if (query.isEmpty) {
      emit(const InitialState<SearchHashtagsResponseModel>());
      return;
    }
    
    emit(LoadingState<SearchHashtagsResponseModel>(currentData: currentSearchData));

    try {
      final ApiResponse<SearchHashtagsResponseModel> response =
          await discoverRepo.searchHashtags(
        query: query,
        page: 1,
        pageSize: 50,
        sortBy: 'relevance',
      );
      
      response.when(
        successful: (Successful<SearchHashtagsResponseModel> data) {
          emit(SuccessState<SearchHashtagsResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<SearchHashtagsResponseModel> error) {
          emit(FailureState<SearchHashtagsResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<SearchHashtagsResponseModel>('Search failed: $e'));
    }
  }
}
