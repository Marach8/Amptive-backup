import 'package:amptive/src/features/auth/data/models/response/communities_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';

class CommunitiesCubit extends Cubit<ATAppState<CommunitiesResponseModel>> {
  CommunitiesCubit({
    AuthRepo? mockAuthRepo,
  }) : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<CommunitiesResponseModel>());

  final AuthRepo authRepo;

  CommunitiesResponseModel? get currentCommunities => switch (state) {
    InitialState<CommunitiesResponseModel>(
      :final CommunitiesResponseModel? initialData) => initialData,
    LoadingState<CommunitiesResponseModel>(
      :final CommunitiesResponseModel? currentData) => currentData,
    SuccessState<CommunitiesResponseModel>(
      :final CommunitiesResponseModel? newData) => newData,
    FailureState<CommunitiesResponseModel>(
      :final CommunitiesResponseModel? oldData) => oldData,
  };

  Future<void> fetchCommunities() async {
    final bool hasMore = currentCommunities?.hasMore ?? true;
    if(state is LoadingState<CommunitiesResponseModel> || !hasMore) {
      return;
    }

    emit(LoadingState<CommunitiesResponseModel>(currentData: currentCommunities));
    try {
      final ApiResponse<CommunitiesResponseModel> response = await authRepo.fetchCommunities(
        pageNo: (currentCommunities?.page ?? 0) + 1,
        pageSize: 20,
      );

      response.when(
        successful: (Successful<CommunitiesResponseModel> data) {
          final Map<String, Community>? newCommunities = data.data?.communities;
          final List<String>? newCommunityIds = data.data?.communityIds;

          final Map<String, Community> mergedCommunities = <String, Community>{
            ...?currentCommunities?.communities,
            ...?newCommunities,
          };

          final List<String> mergedCommunityIds = <String>[
            ...?currentCommunities?.communityIds,
            ...?newCommunityIds,
          ];

          final CommunitiesResponseModel? newCommunitiesData = currentCommunities?.copyWith(
            communities: mergedCommunities,
            communityIds: mergedCommunityIds,
            page: data.data?.page,
            totalItems: data.data?.totalItems,
            pageSize: data.data?.pageSize,
            totalPages: data.data?.totalPages,
          ) ?? data.data;

          emit(SuccessState<CommunitiesResponseModel>(newData: newCommunitiesData));
        },
        unSuccessful: (Unsuccessful<CommunitiesResponseModel> error) {
          emit(
            FailureState<CommunitiesResponseModel>(error.error.message),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<CommunitiesResponseModel>('Unable to get communities: $e'),
      );
    }
  }
}
