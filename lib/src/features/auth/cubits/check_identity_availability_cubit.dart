import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';

class CheckIdentityAvailabilityCubit extends Cubit<ATAppState<bool>> {
  CheckIdentityAvailabilityCubit({
    AuthRepo? mockAuthRepo,
  })  : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<bool>());

  final AuthRepo authRepo;

  bool? get currentAvailability => switch (state) {
        InitialState<bool>(:final bool? initialData) => initialData,
        LoadingState<bool>(:final bool? currentData) => currentData,
        SuccessState<bool>(:final bool? newData) => newData,
        FailureState<bool>(:final bool? oldData) => oldData,
      };

  Future<void> checkIdentityAvailability({
    required Map<String, dynamic> param,
  }) async {
    if (state is LoadingState<bool>) return;
    emit(const LoadingState<bool>());
    try {
      final ApiResponse<bool> response =
          await authRepo.checkIdentityAvailability(param: param);
      response.when(
        successful: (Successful<bool> data) {
          emit(SuccessState<bool>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<bool> error) {
          emit(
            FailureState<bool>(error.error.message),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<bool>('Unable to check identity availability: $e'),
      );
    }
  }

  /// Resets state to initial (clears the suffix icon)
  void reset() => emit(const InitialState<bool>());
}
