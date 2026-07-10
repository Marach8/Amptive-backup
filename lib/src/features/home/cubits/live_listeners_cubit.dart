import 'dart:developer' show log;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/response/live_listeners_response_model.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveListenersCubit extends Cubit<ATAppState<LiveListenersResponseModel>> {
  LiveListenersCubit({HomeRepo? mockHomeRepo})
      : homeRepo = mockHomeRepo ?? HomeRepoImpl(),
        super(const InitialState<LiveListenersResponseModel>());

  final HomeRepo homeRepo;
  String? _cachedLiveStreamId;

  Future<void> fetchLiveListeners({
    String? liveStreamId,
  }) async {
    _cachedLiveStreamId ??= liveStreamId;
    emit(const LoadingState<LiveListenersResponseModel>());

    try {
      final ApiResponse<LiveListenersResponseModel> response = 
      await homeRepo.fetchLiveListeners(
        liveStreamId: liveStreamId ?? _cachedLiveStreamId ?? '');

      await response.when(
        successful: (Successful<LiveListenersResponseModel> data) {
          emit(SuccessState<LiveListenersResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<LiveListenersResponseModel> error) {
          emit(FailureState<LiveListenersResponseModel>(error.error.message));
        },
      );
    }
    catch (e) {
      log('This is teh error $e');
      emit(const FailureState<LiveListenersResponseModel>(
        'Unable to get live listeners'));
    }
  }
}
