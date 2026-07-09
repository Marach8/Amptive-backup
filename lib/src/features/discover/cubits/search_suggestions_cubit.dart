import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchSuggestionsCubit extends Cubit<ATAppState<dynamic>>
    with SafeEmit<ATAppState<dynamic>> {
  SearchSuggestionsCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<dynamic>());
  final DiscoverRepo discoverRepo;

  dynamic get currentSearchData => switch (state) {
    InitialState<dynamic>(:final dynamic initialData) => initialData,
    LoadingState<dynamic>(:final dynamic currentData) => currentData,
    SuccessState<dynamic>(:final dynamic newData) => newData,
    FailureState<dynamic>(:final dynamic oldData) => oldData,
  };

  Future<void> searchSuggestions(String query) async {
    // Hashtags are stored without the '#' — strip it so '#gre' still
    // matches. The API also requires q >= 2 chars; don't fire doomed 422s.
    query = query.trim().replaceFirst(RegExp(r'^#+'), '');
    if (query.length < 2) {
      emit(const InitialState<dynamic>());
      return;
    }
    
    emit(const LoadingState<dynamic>());

    try {
      final ApiResponse<dynamic> response =
          await discoverRepo.searchSuggestions(
        query: query,
      );
      
      response.when(
        successful: (Successful<dynamic> data) {
          // Raw body: {status, message, data: {query, suggestions: [...]}}
          final dynamic body = data.data;
          List<String> suggestions = <String>[];
          if (body is Map) {
            final dynamic rawList = body['data']?['suggestions'];
            if (rawList is List) {
              suggestions = List<String>.from(rawList);
            }
          }
          emit(SuccessState<dynamic>(newData: suggestions));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<dynamic>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<dynamic>('Search failed: $e'));
    }
  }
        
}
