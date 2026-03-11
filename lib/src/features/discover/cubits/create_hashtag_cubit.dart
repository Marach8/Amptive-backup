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

  Future<HashTag?> createHashtag(String name) async {
    emit(LoadingState<HashTag>());

    try {
      final ApiResponse<HashTag> response = await discoverRepo.createHashtag(
        name: name,
        displayName: name,
      );

      return response.when(
        successful: (Successful<HashTag> data) {
          emit(SuccessState<HashTag>(newData: data.data));
          return data.data;
        },
        unSuccessful: (Unsuccessful<HashTag> error) {
          emit(FailureState<HashTag>(error.error.message));
          return null;
        },
      );
    } catch (e) {
      emit(FailureState<HashTag>('Unable to create hashtag: $e'));
      return null;
    }
  }

  void reset() => emit(const InitialState<HashTag>());
}
