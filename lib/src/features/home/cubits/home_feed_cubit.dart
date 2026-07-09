import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Session-long feed cubit shared by the community screens, so re-opening
/// a community shows cached content instantly instead of a spinner.
/// Reset on logout so a new account never sees the previous one's feed.
final HomeFeedCubit communityFeedCubit = HomeFeedCubit();

class HomeFeedCubit extends Cubit<ATAppState<HomeFeedResponseModel>>
    with SafeEmit<ATAppState<HomeFeedResponseModel>> {
  HomeFeedCubit({HomeRepo? mockHomeRepo})
      : homeRepo = mockHomeRepo ?? HomeRepoImpl(),
        super(_cachedData == null
            ? const InitialState<HomeFeedResponseModel>()
            : SuccessState<HomeFeedResponseModel>(newData: _cachedData));

  static HomeFeedResponseModel? _cachedData;

  final HomeRepo homeRepo;

  HomeFeedResponseModel? get currentHomeFeedData => switch (state) {
        InitialState<HomeFeedResponseModel>(
          :final HomeFeedResponseModel? initialData
        ) =>
          initialData,
        LoadingState<HomeFeedResponseModel>(
          :final HomeFeedResponseModel? currentData
        ) =>
          currentData,
        SuccessState<HomeFeedResponseModel>(
          :final HomeFeedResponseModel? newData
        ) =>
          newData,
        FailureState<HomeFeedResponseModel>(
          :final HomeFeedResponseModel? oldData
        ) =>
          oldData,
      };

  Future<void> fetchHomeFeed() async {
    final bool hasMore = currentHomeFeedData?.hasMore ?? true;
    if (state is LoadingState<HomeFeedResponseModel> || !hasMore) {
      return;
    }

    emit(LoadingState<HomeFeedResponseModel>(currentData: currentHomeFeedData));

    try {
      final int nextPage = (currentHomeFeedData?.page ?? 0) + 1;
      final ApiResponse<HomeFeedResponseModel> response =
          await homeRepo.fetchHomeFeed(
        page: nextPage,
        pageSize: 20,
        // Force the backend to regenerate its cached feed on the first page
        // of a session so newly created episodes/events show up; subsequent
        // pages keep paging the same snapshot.
        refresh: nextPage == 1,
      );
      response.when(
        successful: (Successful<HomeFeedResponseModel> data) {
          final List<HomeFeedItem>? oldFeedItems =
              currentHomeFeedData?.homeFeedItems;
          final List<HomeFeedItem>? newFeedItems = data.data?.homeFeedItems;

          final List<HomeFeedItem> mergedFeedItems = <HomeFeedItem>[
            ...?oldFeedItems,
            ...?newFeedItems
          ];
          final HomeFeedResponseModel newData = HomeFeedResponseModel(
            homeFeedItems: mergedFeedItems,
            hasMore: data.data?.hasMore ?? true,
            page: data.data?.page,
            pageSize: data.data?.pageSize,
          );
          _cachedData = newData;
          emit(SuccessState<HomeFeedResponseModel>(newData: newData));
        },
        unSuccessful: (Unsuccessful<HomeFeedResponseModel> error) {
          emit(FailureState<HomeFeedResponseModel>(error.error.message,
              oldData: currentHomeFeedData));
        },
      );
    } catch (e) {
      emit(FailureState<HomeFeedResponseModel>('Unable to get home feed: $e',
          oldData: currentHomeFeedData));
    }
  }

  /// Drops all cached feed data (used on logout).
  void reset() => emit(const InitialState<HomeFeedResponseModel>());

  Future<void> refreshHomeFeed() async {
    if (state is LoadingState<HomeFeedResponseModel>) return;
    emit(LoadingState<HomeFeedResponseModel>(currentData: currentHomeFeedData));

    try {
      final ApiResponse<HomeFeedResponseModel> response =
          await homeRepo.fetchHomeFeed(
        page: 1,
        pageSize: 20,
        refresh: true,
      );
      response.when(
        successful: (Successful<HomeFeedResponseModel> data) {
          _cachedData = data.data;
          emit(SuccessState<HomeFeedResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HomeFeedResponseModel> error) {
          emit(FailureState<HomeFeedResponseModel>(error.error.message,
              oldData: currentHomeFeedData));
        },
      );
    } catch (e) {
      emit(FailureState<HomeFeedResponseModel>('Unable to get home feed: $e',
          oldData: currentHomeFeedData));
    }
  }
}
