import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateHashtagCubit extends Cubit<ATAppState<HashTag>> {
  CreateHashtagCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<HashTag>());

  final DiscoverRepo discoverRepo;

  // Changed return type to Future<void>
  Future<void> createHashtag(String name) async {
    emit(const LoadingState<HashTag>());

    try {
      final ApiResponse<HashTag> response = await discoverRepo.createHashtag(
        name: name,
        displayName: name,
      );

      response.when(
        successful: (Successful<HashTag> data) {
          emit(SuccessState<HashTag>(newData: data.data));
          // No return needed
        },
        unSuccessful: (Unsuccessful<HashTag> error) {
          emit(FailureState<HashTag>(error.error.message));
          // No return needed
        },
      );
    } catch (e) {
      emit(FailureState<HashTag>('Unable to create hashtag: $e'));
    }
  }

  void reset() => emit(const InitialState<HashTag>());
}