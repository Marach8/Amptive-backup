import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveWhispersCubit extends Cubit<ATAppState<dynamic>> {
  LiveWhispersCubit({HomeRepo? mockHomeRepo})
      : homeRepo = mockHomeRepo ?? HomeRepoImpl(),
        super(const InitialState<dynamic>());

  final HomeRepo homeRepo;

  Future<void> fetchWhispers({
    required String livestreamId,
    int? limit,
    String? beforeId,
  }) async {
    emit(LoadingState<dynamic>());

    try {
      final ApiResponse<dynamic> response = await homeRepo.fetchLivestreamChat(
        livestreamId: livestreamId,
      );

      response.when(
        successful: (Successful<dynamic> data) {
          emit(SuccessState<dynamic>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<dynamic>(
            error.error.message,
          ));
        },
      );
    } catch (e) {
      emit(FailureState<dynamic>('Unable to get chat: $e'));
    }
  }
}
