import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/search_events_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchEventsCubit extends Cubit<ATAppState<SearchEventsResponseModel>> {
  SearchEventsCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<SearchEventsResponseModel>());

  final DiscoverRepo discoverRepo;

  SearchEventsResponseModel? get currentSearchData => switch (state) {
    InitialState<SearchEventsResponseModel>(:final SearchEventsResponseModel? initialData) => initialData,
    LoadingState<SearchEventsResponseModel>(:final SearchEventsResponseModel? currentData) => currentData,
    SuccessState<SearchEventsResponseModel>(:final SearchEventsResponseModel? newData) => newData,
    FailureState<SearchEventsResponseModel>(:final SearchEventsResponseModel? oldData) => oldData,
  };

  Future<void> searchEvents(String query) async {
    if (query.isEmpty) {
      emit(const InitialState<SearchEventsResponseModel>());
      return;
    }
    
    emit(const LoadingState<SearchEventsResponseModel>());

    try {
      final ApiResponse<SearchEventsResponseModel> response =
          await discoverRepo.searchEvents(
        query: query,
        page: 1,
        pageSize: 100,
        sortBy: 'relevance',
        // category: null,
        // status: null,
        // showType: null,
        // hostId: null,

      );
      
      response.when(
        successful: (Successful<SearchEventsResponseModel> data) {
          emit(SuccessState<SearchEventsResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<SearchEventsResponseModel> error) {
          emit(FailureState<SearchEventsResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<SearchEventsResponseModel>('Search failed: $e'));
    }
  }
}
