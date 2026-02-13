import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit <ATAppState<dynamic>>{
  LoginCubit ({
    AuthRepo ? mockAuthRepo
  }): authRepo = mockAuthRepo ?? AuthRepoImpl(),
  super (const InitialState<dynamic> ());

  final AuthRepo authRepo;
  Future <void> loginUser ({
    required Map<String, dynamic> param
  }) async {
    emit(const LoadingState<dynamic>());
    try{

      final ApiResponse<dynamic> response = await authRepo.loginUser(
        param: param);
        response.when(
          successful: (Successful<dynamic> data) {
            emit(SuccessState<dynamic>(newData: data.data));

          },
           unSuccessful: (Unsuccessful<dynamic> error){
            emit(FailureState<dynamic>(error.error.message));
           }
            );
    }catch (e) {
      emit(FailureState<dynamic>('Unable to login user: $e')
      );
    }

    
  }
}