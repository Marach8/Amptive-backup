import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterDeviceFCMCubit extends Cubit<ATAppState<bool>> {
  RegisterDeviceFCMCubit({AuthRepo? mockAuthRepo})
      : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<bool>());

  final AuthRepo authRepo;

  Future<void> registerDevice({
    required String userId,
    required String fcmToken,
    required String deviceName,
    required String platform,
  }) async {
    emit(const LoadingState<bool>());
    try {
      final ApiResponse<String> response = await authRepo.registerDevice(
        userId: userId,
        fcmToken: fcmToken,
        deviceName: deviceName,
        platform: platform,
      );
      response.when(
        successful: (Successful<String> data) {
          emit(const SuccessState<bool>(newData: true));
        },
        unSuccessful: (Unsuccessful<String> error) {
          emit(FailureState<bool>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<bool>('Unable to register device: $e'));
    }
  }
}
