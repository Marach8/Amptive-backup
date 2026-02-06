import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';

class VerifyOtpCubit extends Cubit<ATAppState<dynamic>> {
  VerifyOtpCubit({
    AuthRepo? mockAuthRepo,
  }) : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<dynamic>());

  final AuthRepo authRepo;

  dynamic get currentResponse => switch (state) {
    InitialState<dynamic>(:final dynamic initialData) => initialData,
    LoadingState<dynamic>(:final dynamic currentData) => currentData,
    SuccessState<dynamic>(:final dynamic newData) => newData,
    FailureState<dynamic>(:final dynamic oldData) => oldData,
  };

  Future<void> verifyOtp({
    required Map<String, dynamic> param,
  }) async {
    emit(const LoadingState<dynamic>());
    try {
      final ApiResponse<dynamic> response = await authRepo.verifyOtp(param: param);
      response.when(
        successful: (Successful<dynamic> data) {
          emit(SuccessState<dynamic>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(
            FailureState<dynamic>(error.error.message),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<dynamic>('Unable to verify OTP: $e'),
      );
    }
  }
}
