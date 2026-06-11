import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinCommunitiesCubit extends Cubit<ATAppState<bool>> {
  JoinCommunitiesCubit({
    DiscoverRepo? mockDiscoverRepo,
  }) : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<bool>());

  final DiscoverRepo discoverRepo;

  Future<void> joinCommunities({
    required List<String> communityIds,
  }) async {
    emit(const LoadingState<bool>());
    try {
      final ApiResponse<bool> response = 
        await discoverRepo.joinCommunities(
          communityIds: communityIds,
        );

      response.when(
        successful: (Successful<bool> data) async {
          emit(SuccessState<bool>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<bool> error) {
          emit(FailureState<bool>(error.error.message));
        },
      );
    } catch (_) {
      emit(const FailureState<bool>('Unable to join communities'));
    }
  }
}
