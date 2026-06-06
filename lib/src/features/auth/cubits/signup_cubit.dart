import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/features/auth/data/models/response/auth_success_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';

class SignupCubit extends Cubit<ATAppState<SignUpResponseModel>> {
  SignupCubit({
    AuthRepo? mockAuthRepo,
    ATLocalStorageService? mockLocalStorageService,
  })  : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        localStorageService =
            mockLocalStorageService ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<SignUpResponseModel>());

  final AuthRepo authRepo;
  final ATLocalStorageService localStorageService;

  Future<void> signupUser({
    required RegistrationData param,
  }) async {
    emit(const LoadingState<SignUpResponseModel>());
    try {
      final ApiResponse<SignUpResponseModel> response =
          await authRepo.registerUser(param: param);
      response.when(
        successful: (Successful<SignUpResponseModel> data) async {
          final SignUpResponseModel? responseModel = data.data;
          final String? accessToken = responseModel?.accessToken;
          final String? userName = responseModel?.user?.username;
          final String? email = responseModel?.user?.email;
          final String? name = responseModel?.user?.name;
          final String? userId = responseModel?.user?.id;
          final String? dob = responseModel?.user?.dob;

          if (accessToken != null) {
            await localStorageService.set(ATStrings.accessToken, accessToken);
          }
          final CachedUserData cachedUserData = CachedUserData(
            username: userName,
            email: email,
            name: name,
            userId: userId,
            dob: dob,
          );
          await localStorageService.setObject(
            ATStrings.cachedUserData,
            cachedUserData.toLocalStorageJson(),
          );

          emit(SuccessState<SignUpResponseModel>(newData: responseModel));
        },
        unSuccessful: (Unsuccessful<SignUpResponseModel> error) {
          emit(
            FailureState<SignUpResponseModel>(error.error.message),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<SignUpResponseModel>('Unable to signup user: $e'),
      );
    }
  }
}
