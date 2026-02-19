import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit <ATAppState<String>>{
  ResetPasswordCubit ({
    AuthRepo ? mockAuthRepo
  }): authRepo = mockAuthRepo ?? AuthRepoImpl(),
  super (const InitialState<String> ());

  final AuthRepo authRepo;

  Future <void> resetPassword ({
    required Map<String, dynamic> param
  }) async {
    emit(const LoadingState<String>());
    try{

      final ApiResponse<String> response = await authRepo.resetPassword(
        param: param);
        response.when(
          successful: (Successful<String> data) {
            emit(const SuccessState<String>(newData: ''));

          },
           unSuccessful: (Unsuccessful<String> error){
            emit(FailureState<String>(error.error.message));
           }
            );
    }catch (e) {
      emit(FailureState<String>('Unable to reset password: $e')
      );
    }

    
  }
}