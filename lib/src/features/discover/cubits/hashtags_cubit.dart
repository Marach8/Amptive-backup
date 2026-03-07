import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HashtagsCubit extends Cubit<ATAppState<dynamic>> {
  HashtagsCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<dynamic>());

  final DiscoverRepo discoverRepo;
  dynamic _cachedTags;

  dynamic get currentTagsData => switch (state) {
        InitialState<dynamic>(:final dynamic initialData) => initialData,
        LoadingState<dynamic>(:final dynamic currentData) => currentData,
        SuccessState<dynamic>(:final dynamic newData) => newData,
        FailureState<dynamic>(:final dynamic oldData) => oldData,
      };

  Future<void> fetchTags() async {
    if (state is LoadingState<dynamic>) {
      return;
    }

    emit(LoadingState<dynamic>(currentData: currentTagsData));

    try {
      final ApiResponse<dynamic> response = await discoverRepo.fetchTags(
        page: 1,
        pageSize: 50,
      );
      response.when(
        successful: (Successful<dynamic> data) {
          _cachedTags = data.data;
          emit(SuccessState<dynamic>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<dynamic>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<dynamic>('Unable to get hashtags: $e'));
    }
  }

  void reset() => emit(const InitialState<dynamic>());
}
