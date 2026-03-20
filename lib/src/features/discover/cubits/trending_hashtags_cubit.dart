import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/trending_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingHashtagsCubit extends Cubit<ATAppState<TrendingTagsResponseModel>> {
  TrendingHashtagsCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<TrendingTagsResponseModel>());

  final DiscoverRepo discoverRepo;

  TrendingTagsResponseModel? get currentTrendingTags => switch (state) {
    InitialState<TrendingTagsResponseModel>(:final TrendingTagsResponseModel? initialData) =>initialData,
    LoadingState<TrendingTagsResponseModel>(:final TrendingTagsResponseModel? currentData) => currentData,
    SuccessState<TrendingTagsResponseModel>(:final TrendingTagsResponseModel? newData) => newData,
    FailureState<TrendingTagsResponseModel>(:final TrendingTagsResponseModel? oldData) => oldData,
  };

  Future<void> fetchTrendingTags({
    int page = 1,
    int limit = 50,
    String? tagType,
  }) async {
    emit(LoadingState<TrendingTagsResponseModel>(currentData: currentTrendingTags));

    try {
      final ApiResponse<TrendingTagsResponseModel> response = await discoverRepo.fetchTrendingTags(
        limit: limit,
        tagType: tagType,
      );

      response.when(
        successful: (Successful<TrendingTagsResponseModel> data) {
          emit(SuccessState<TrendingTagsResponseModel>(
            newData: data.data,
          ));
          
        },
        unSuccessful: (Unsuccessful<TrendingTagsResponseModel> error) {
          emit(FailureState<TrendingTagsResponseModel>(
            error.error.message,
          ));
        },
      );
    } catch (e) {
      emit(FailureState<TrendingTagsResponseModel>(
        'Unable to get trending tags: $e',
      ));
    }
  }

  Future<void> filterByTagType(String? tagType) async {
    await fetchTrendingTags(
      page: 1,
      limit: 20,
      tagType: tagType,
    );
  }
}
