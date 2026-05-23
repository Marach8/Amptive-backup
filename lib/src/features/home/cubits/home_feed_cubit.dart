import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeFeedCubit extends Cubit<ATAppState<HomeFeedResponseModel>> {
  HomeFeedCubit({HomeRepo? mockHomeRepo})
      : homeRepo = mockHomeRepo ?? HomeRepoImpl(),
        super(const InitialState<HomeFeedResponseModel>());

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
      final ApiResponse<HomeFeedResponseModel> response =
          await homeRepo.fetchHomeFeed(
        page: (currentHomeFeedData?.page ?? 0) + 1,
        pageSize: 20,
        refresh: false,
      );
      response.when(
        successful: (Successful<HomeFeedResponseModel> data) {
          final List<HomeFeedItem>? oldFeedItems = currentHomeFeedData?.homeFeedItems;
          final List<HomeFeedItem>? newFeedItems = data.data?.homeFeedItems;

          final List<HomeFeedItem> mergedFeedItems = <HomeFeedItem>[...?oldFeedItems, ...?newFeedItems];
          final HomeFeedResponseModel newData = HomeFeedResponseModel(
            homeFeedItems: mergedFeedItems,
            hasMore: data.data?.hasMore ?? true,
            page: data.data?.page,
            pageSize: data.data?.pageSize,
          );
          emit(SuccessState<HomeFeedResponseModel>(newData: newData));
        },
        unSuccessful: (Unsuccessful<HomeFeedResponseModel> error) {
          emit(FailureState<HomeFeedResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<HomeFeedResponseModel>('Unable to get home feed: $e'));
    }
  }


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
          emit(SuccessState<HomeFeedResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HomeFeedResponseModel> error) {
          emit(FailureState<HomeFeedResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<HomeFeedResponseModel>('Unable to get home feed: $e'));
    }
  }
}
