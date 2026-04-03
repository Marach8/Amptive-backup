import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/unified_search_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnifiedSearchCubit extends Cubit<ATAppState<UnifiedSearchResponseModel>> {
  UnifiedSearchCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<UnifiedSearchResponseModel>());

  final DiscoverRepo discoverRepo;

  UnifiedSearchResponseModel? get currentSearchData => switch (state) {
    InitialState<UnifiedSearchResponseModel>(:final UnifiedSearchResponseModel? initialData) => initialData,
    LoadingState<UnifiedSearchResponseModel>(:final UnifiedSearchResponseModel? currentData) => currentData,
    SuccessState<UnifiedSearchResponseModel>(:final UnifiedSearchResponseModel? newData) => newData,
    FailureState<UnifiedSearchResponseModel>(:final UnifiedSearchResponseModel? oldData) => oldData,
  };

  Future<void> searchAll(String query) async {
    if (query.isEmpty) {
      emit(const InitialState<UnifiedSearchResponseModel>());
      return;
    }
    
    emit(const LoadingState<UnifiedSearchResponseModel>());

    try {
      final ApiResponse<UnifiedSearchResponseModel> response =
          await discoverRepo.unifiedSearch(
        query: query,
        sortBy: 'relevance',
      );
      
      response.when(
        successful: (Successful<UnifiedSearchResponseModel> data) {
          emit(SuccessState<UnifiedSearchResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<UnifiedSearchResponseModel> error) {
          emit(FailureState<UnifiedSearchResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<UnifiedSearchResponseModel>('Search failed: $e'));
    }
  }
}
