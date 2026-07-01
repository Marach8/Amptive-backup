import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/shows/data/models/response/followed_shows_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowedShowsCubit extends Cubit<ATAppState<FollowedShowsResponseModel>> {
  FollowedShowsCubit({ShowsRepo? mockShowsRepo})
      : showsRepo = mockShowsRepo ?? ShowsRepoImpl(),
        super(const InitialState<FollowedShowsResponseModel>());

  final ShowsRepo showsRepo;

  FollowedShowsResponseModel? get currentFollowedShows => switch (state) {
        SuccessState<FollowedShowsResponseModel>(:final FollowedShowsResponseModel? newData) => newData,
        FailureState<FollowedShowsResponseModel>(:final FollowedShowsResponseModel? oldData) => oldData,
        InitialState<FollowedShowsResponseModel>(:final FollowedShowsResponseModel? initialData) => initialData,
        LoadingState<FollowedShowsResponseModel>(:final FollowedShowsResponseModel? currentData) => currentData,
      };

  List<FollowedShowItem> get followedShowsItems {
    final FollowedShowsResponseModel? data = currentFollowedShows;
    return data?.items ?? <FollowedShowItem>[];
  }

  List<FollowedShowItem> get scheduledShowsItems {
    final FollowedShowsResponseModel? data = currentFollowedShows;
    if (data?.items == null) return <FollowedShowItem>[];
        return data!.items!
        .where((FollowedShowItem item) => 
            item.status == 'SCHEDULED')
        .toList();
  }

  List<FollowedShowItem> get liveShowsItems {
    final FollowedShowsResponseModel? data = currentFollowedShows;
    if (data?.items == null) return <FollowedShowItem>[];
    
    return data!.items!
        .where((FollowedShowItem item) => 
            item.status == 'LIVE')
        .toList();
  }

  // List<FollowedShowItem> get endedShowsItems {
  //   final FollowedShowsResponseModel? data = currentFollowedShows;
  //   if (data?.items == null) return <FollowedShowItem>[];
    
  //   return data!.items!
  //       .where((FollowedShowItem item) => 
  //           item.status?.toUpperCase() == 'ENDED')
  //       .toList();
  // }

  Future<void> fetchFollowedShows() async {
    emit(const LoadingState<FollowedShowsResponseModel>());
   // final bool hasMore = currentFollowedShows?.hasMore ?? true;
    try {
      final ApiResponse<FollowedShowsResponseModel> response = await showsRepo.fetchFollowedShows(
        page: (currentFollowedShows?.page ?? 0) + 1,
        pageSize: 20,
        refresh: false,
      );
      response.when(
        successful: (Successful<FollowedShowsResponseModel> data) {
          emit(SuccessState<FollowedShowsResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<FollowedShowsResponseModel> error) {
          emit(FailureState<FollowedShowsResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<FollowedShowsResponseModel>('Unable to get followed shows: $e'));
    }
  }
}
