import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/all_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllHashtagsCubit extends Cubit<ATAppState<AllHashtagsResponseModel>> {
  AllHashtagsCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<AllHashtagsResponseModel>());

  final DiscoverRepo discoverRepo;

  AllHashtagsResponseModel? get currentTagsData => switch (state) {
    InitialState<AllHashtagsResponseModel>(:final AllHashtagsResponseModel? initialData) =>
      initialData,
    LoadingState<AllHashtagsResponseModel>(:final AllHashtagsResponseModel? currentData) =>
      currentData,
    SuccessState<AllHashtagsResponseModel>(:final AllHashtagsResponseModel? newData) =>
      newData,
    FailureState<AllHashtagsResponseModel>(:final AllHashtagsResponseModel? oldData) =>
      oldData,
  };

  List<HashTag> _cachedHashTags = <HashTag>[];

  Future<void> fetchHashTags() async {
    final bool hasMore = currentTagsData?.hasMore ?? true;
    if (state is LoadingState<AllHashtagsResponseModel> || !hasMore) {
      return;
    }

    emit(LoadingState<AllHashtagsResponseModel>(currentData: currentTagsData));

    try {
      final ApiResponse<AllHashtagsResponseModel> response =
          await discoverRepo.fetchHashTags(
        page: (currentTagsData?.page ?? 0) + 1,
        pageSize: 20,
      );

      response.when(
        successful: (Successful<AllHashtagsResponseModel> data) {
          final List<HashTag>? newlyFetchedTags = data.data?.hashtags;
          final List<HashTag>? currentTags = currentTagsData?.hashtags;
          final List<HashTag> mergedHashtags = <HashTag>[
            ...?currentTags, ...?newlyFetchedTags,
          ];

          final AllHashtagsResponseModel? updatedData = currentTagsData?.copyWith(
            hashtags: mergedHashtags,
            total: data.data?.total,
            page: data.data?.page,
            pageSize: data.data?.pageSize,
            totalPages: data.data?.totalPages,
          ) ?? data.data;

          emit(SuccessState<AllHashtagsResponseModel>(newData: updatedData));
          _cachedHashTags = mergedHashtags;
        },
        unSuccessful: (Unsuccessful<AllHashtagsResponseModel> error) {
          emit(FailureState<AllHashtagsResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<AllHashtagsResponseModel>('Unable to get hashtags: $e'));
    }
  }


  Future<void> searchHashtags(String query) async {
    final List<HashTag> allHashtags = currentTagsData?.hashtags ?? <HashTag>[];
    if (allHashtags.isEmpty) {
      return;
    }

    if (query.isEmpty) {
      emit(SuccessState<AllHashtagsResponseModel>(
        newData: currentTagsData?.copyWith(
          hashtags: _cachedHashTags,
        ),
      ));
      return;
    }

    emit(LoadingState<AllHashtagsResponseModel>(currentData: currentTagsData)); 

    final List<HashTag> filteredHashtags = allHashtags
        .where((HashTag hashtag) => 
          (hashtag.name?.toLowerCase().contains(query.toLowerCase()) ??
                false) || 
          (hashtag.displayName?.toLowerCase().contains(query.toLowerCase()) ??
                false)
        ).toList();

    if (filteredHashtags.isEmpty) {
      emit(
        FailureState<AllHashtagsResponseModel>(
          'No hashtags found matching "$query".',
          oldData: currentTagsData,
        ),
      );
      return;
    }

    final AllHashtagsResponseModel? filteredData = currentTagsData?.copyWith(
      hashtags: filteredHashtags,
    );

    emit(SuccessState<AllHashtagsResponseModel>(newData: filteredData));
  }

  void resetSearch() => emit(SuccessState<AllHashtagsResponseModel>(
    newData: currentTagsData?.copyWith(
      hashtags: _cachedHashTags,
    ),
  ));

}
