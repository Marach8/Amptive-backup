import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';

class SendOtpCubit extends Cubit<ATAppState<String>> {
  SendOtpCubit({
    AuthRepo? mockAuthRepo,
  }) : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<String>());

  final AuthRepo authRepo;

  String? get currentOtp => switch (state) {
    InitialState<String>(:final String? initialData) => initialData,
    LoadingState<String>(:final String? currentData) => currentData,
    SuccessState<String>(:final String? newData) => newData,
    FailureState<String>(:final String? oldData) => oldData,
  };

  Future<void> sendOtp({
    required Map<String, dynamic> param,
  }) async {
    if (state is LoadingState<String>) return;
    emit(const LoadingState<String>());
    try {
      final ApiResponse<String?> response =
          await authRepo.sendOtp(param: param);
      response.when(
        successful: (Successful<String?> data) {
          emit(SuccessState<String>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<String?> error) {
          emit(
            FailureState<String>(error.error.message),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<String>('Unable to send OTP: $e'),
      );
    }
  }
}
