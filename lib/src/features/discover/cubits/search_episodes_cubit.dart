import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/search_events_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Searches episode-type events (created under a show). These live in their
/// own search index — `/search/events` only covers standalone events.
class SearchEpisodesCubit extends Cubit<ATAppState<SearchEventsResponseModel>>
    with SafeEmit<ATAppState<SearchEventsResponseModel>> {
  SearchEpisodesCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<SearchEventsResponseModel>());

  final DiscoverRepo discoverRepo;

  SearchEventsResponseModel? get currentSearchData => switch (state) {
        InitialState<SearchEventsResponseModel>(
          :final SearchEventsResponseModel? initialData
        ) =>
          initialData,
        LoadingState<SearchEventsResponseModel>(
          :final SearchEventsResponseModel? currentData
        ) =>
          currentData,
        SuccessState<SearchEventsResponseModel>(
          :final SearchEventsResponseModel? newData
        ) =>
          newData,
        FailureState<SearchEventsResponseModel>(
          :final SearchEventsResponseModel? oldData
        ) =>
          oldData,
      };

  Future<void> searchEpisodes(String query) async {
    if (query.isEmpty) {
      emit(const InitialState<SearchEventsResponseModel>());
      return;
    }

    emit(LoadingState<SearchEventsResponseModel>(
        currentData: currentSearchData));

    try {
      final ApiResponse<SearchEventsResponseModel> response =
          await discoverRepo.searchEpisodes(
        query: query,
        page: 1,
        pageSize: 100,
        sortBy: 'relevance',
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
