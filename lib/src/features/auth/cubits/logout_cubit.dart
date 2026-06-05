import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';

class LogoutCubit extends Cubit<ATAppState<bool>> {
  LogoutCubit({
    AuthRepo? mockAuthRepo,
    ATLocalStorageService? mockLocalStorageService,
  })  : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        localStorageService = mockLocalStorageService 
          ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<bool>());

  final AuthRepo authRepo;
  final ATLocalStorageService localStorageService;

  bool? get currentResponse => switch (state) {
        InitialState<bool>(:final bool? initialData) => initialData,
        LoadingState<bool>(:final bool? currentData) => currentData,
        SuccessState<bool>(:final bool? newData) => newData,
        FailureState<bool>(:final bool? oldData) => oldData,
      };

  Future<void> logout() async {
    emit(const LoadingState<bool>());

    try {
      final ApiResponse<bool> response = await authRepo.logout();

      response.when(
        successful: (_)async{
          await localStorageService.remove(ATStrings.accessToken);
          await localStorageService.remove(ATStrings.refreshToken);
          await localStorageService.remove(ATStrings.cachedUserData);
          emit(
            const SuccessState<bool>(
              newData: true,
            ),
          );
        },
        unSuccessful: (Unsuccessful<bool> error) {
          emit(
            FailureState<bool>(
              error.error.message,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<bool>(
          'Unable to logout: $e',
        ),
      );
    }
  }
}
