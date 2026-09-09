import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailAndPhoneNoOtpCubit extends Cubit<ATAppState<dynamic>> {
  VerifyEmailAndPhoneNoOtpCubit({
    ProfileRepo? mockProfileRepo,
  })  : profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
        super(const InitialState<dynamic>());

  final ProfileRepo profileRepo;

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
      final ApiResponse<dynamic> response =
          await profileRepo.verifyOtp(param: param);
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
