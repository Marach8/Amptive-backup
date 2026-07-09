import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MockFeedState {}

class MockFeedInitial extends MockFeedState {}
class MockFeedLoading extends MockFeedState {}
class MockFeedLoaded extends MockFeedState {}

class MockFeedCubit extends Cubit<MockFeedState> {
  MockFeedCubit() : super(MockFeedInitial());

  Future<void> fetchFeed() async {
    if (state is MockFeedLoaded) {
      // SILENT BACKGROUND REFRESH
      // 1. We immediately return the cached data (no skeletons)
      // 2. We secretly fetch the server in the background
      await Future.delayed(const Duration(milliseconds: 2500));
      // 3. We quietly update the feed with the new data
      if (!isClosed) emit(MockFeedLoaded());
      return;
    }

    emit(MockFeedLoading());
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!isClosed) emit(MockFeedLoaded());
  }

  Future<void> refreshFeed() async {
    emit(MockFeedLoading());
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!isClosed) emit(MockFeedLoaded());
  }
}

class FollowingFeedCubit extends MockFeedCubit {}
class ScheduledFeedCubit extends MockFeedCubit {}
class SubscribedFeedCubit extends MockFeedCubit {}
