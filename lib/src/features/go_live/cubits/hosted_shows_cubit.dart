import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HostedShowsCubit extends Cubit<ATAppState<HostedShowsResponseModel>> {
  HostedShowsCubit({GoLiveRepo? mockGoLiveRepo})
      : goLiveRepo = mockGoLiveRepo ?? GoLiveRepoImpl(),
        super(const InitialState<HostedShowsResponseModel>());

  final GoLiveRepo goLiveRepo;

  HostedShowsResponseModel? get hostedShowsData => switch (state) {
    InitialState<HostedShowsResponseModel>(:final HostedShowsResponseModel? initialData) => initialData,
    LoadingState<HostedShowsResponseModel>(:final HostedShowsResponseModel? currentData) => currentData,
    SuccessState<HostedShowsResponseModel>(:final HostedShowsResponseModel? newData) => newData,
    FailureState<HostedShowsResponseModel>(:final HostedShowsResponseModel? oldData) => oldData,
  };

  Future<void> fetchHostedShows() async {
    final bool hasMore = hostedShowsData?.hasMore ?? true;
    if(state is LoadingState<HostedShowsResponseModel> || !hasMore){
      return;
    }

    emit(LoadingState<HostedShowsResponseModel>(currentData: hostedShowsData));
    try {
      final ApiResponse<HostedShowsResponseModel> response = await goLiveRepo.fetchHostedShows();
      response.when(
        successful: (Successful<HostedShowsResponseModel> data) {
          emit(SuccessState<HostedShowsResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HostedShowsResponseModel> error) {
          emit(FailureState<HostedShowsResponseModel>(
            error.error.message,
            oldData: hostedShowsData
          ));
        },
      );
    } catch (e) {
      emit(FailureState<HostedShowsResponseModel>(
        'Unable to get shows: $e',
        oldData: hostedShowsData
      ));
    }
  }
}
