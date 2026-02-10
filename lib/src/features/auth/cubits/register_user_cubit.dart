import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterUserCubit extends Cubit <ATAppState<String>> {
  RegisterUserCubit ({
    AuthRepo ? mockAuthRepo
  }) : authRepo = mockAuthRepo ?? AuthRepoImpl(),
    super(const InitialState<String>());

    final AuthRepo authRepo;

     String? get currentRegistrationStatus => switch (state) {
      InitialState<String>(:final String? initialData) => initialData,
      LoadingState<String>(:final String? currentData) => currentData,
      SuccessState<String>(:final String? newData) => newData,
      FailureState<String>(:final String? oldData) => oldData,
    };

    Future<void> registerUser({
      required Map<String, dynamic> param,
    }) async {
      if(state is LoadingState<String>) return;
      emit(const LoadingState<String>());
      try {
        final ApiResponse<String> response = await authRepo.registerUser(param: param);
        response.when(
          successful: (Successful<String> data) {
            emit(SuccessState<String> (newData:data.data ));
          },
          unSuccessful: (Unsuccessful<String> error) {
            emit(
              FailureState<String>(error.error.message),
            );
          },
        );
      } catch (e) {
        emit(
          FailureState<String>('Unable to register user: $e'),
        );
      }
    }

}