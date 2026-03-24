import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HostedShowsCubit extends Cubit<ATAppState<HostedShowsResponseModel>> {
  HostedShowsCubit({ShowsRepo? mockShowsRepo})
      : showsRepo = mockShowsRepo ?? ShowsRepoImpl(),
        super(const InitialState<HostedShowsResponseModel>());

  final ShowsRepo showsRepo;

  HostedShowsResponseModel? get currentHostedShowsData => switch (state) {
        InitialState<HostedShowsResponseModel>(
          :final HostedShowsResponseModel? initialData
        ) =>
          initialData,
        LoadingState<HostedShowsResponseModel>(
          :final HostedShowsResponseModel? currentData
        ) =>
          currentData,
        SuccessState<HostedShowsResponseModel>(
          :final HostedShowsResponseModel? newData
        ) =>
          newData,
        FailureState<HostedShowsResponseModel>(
          :final HostedShowsResponseModel? oldData
        ) =>
          oldData,
      };

  Future<void> fetchHostedShows([bool forceRefresh = false]) async {
    final bool hasMore = currentHostedShowsData?.hasMore ?? true;
    if (state is LoadingState<HostedShowsResponseModel> || !hasMore) {
      return;
    }

    emit(LoadingState<HostedShowsResponseModel>(
        currentData: currentHostedShowsData));
    try {
      final ApiResponse<HostedShowsResponseModel> response =
          await showsRepo.fetchHostedShows(
        page: (currentHostedShowsData?.page ?? 0) + 1,
        pageSize: 20,
        refresh: forceRefresh,
      );
      response.when(
        successful: (Successful<HostedShowsResponseModel> data) {
          final List<HostedShow>? newHostedShows = data.data?.hostedShows;
          final List<HostedShow> mergedHostedShows = <HostedShow>[
            ...?currentHostedShowsData?.hostedShows,
            ...?newHostedShows,
          ];

          final HostedShowsResponseModel newData = HostedShowsResponseModel(
            hostedShows: mergedHostedShows,
            total: data.data?.total,
            page: data.data?.page,
            pageSize: data.data?.pageSize,
            hasMore: data.data?.hasMore,
          );
          emit(SuccessState<HostedShowsResponseModel>(newData: newData));
        },
        unSuccessful: (Unsuccessful<HostedShowsResponseModel> error) {
          emit(FailureState<HostedShowsResponseModel>(error.error.message,
              oldData: currentHostedShowsData));
        },
      );
    } catch (e) {
      emit(FailureState<HostedShowsResponseModel>('Unable to get shows: $e',
          oldData: currentHostedShowsData));
    }
  }



  void addNewHostedShow(HostedShow? show) {
    if (show == null) return;
    final List<HostedShow> updatedShows = <HostedShow>[
      show, ...?currentHostedShowsData?.hostedShows,
    ];

    final HostedShowsResponseModel newData = HostedShowsResponseModel(
      hostedShows: updatedShows,
      total: (currentHostedShowsData?.total ?? 0) + 1,
      page: currentHostedShowsData?.page,
      pageSize: currentHostedShowsData?.pageSize,
      hasMore: currentHostedShowsData?.hasMore,
    );

    emit(SuccessState<HostedShowsResponseModel>(newData: newData));
  }
}
