import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/auth_success_response_model.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<ATAppState<ATUser>> {
  LoginCubit(
      {AuthRepo? mockAuthRepo, ATLocalStorageService? mockLocalStorageService})
      : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        localStorageService =
            mockLocalStorageService ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<ATUser>());

  final AuthRepo authRepo;
  final ATLocalStorageService localStorageService;

  Future<void> loginUser({required Map<String, dynamic> param}) async {
    emit(const LoadingState<ATUser>());
    try {
      final ApiResponse<LoginResponseModel> response =
          await authRepo.loginUser(param: param);
      response.when(successful: (Successful<LoginResponseModel> data) async {
        final String? accessToken = data.data?.accessToken;
        final String? refreshToken = data.data?.refreshToken;

        final String? userName = data.data?.user?.username;
        final String? email = data.data?.user?.email;
        final String? name = data.data?.user?.name;
        final String? userId = data.data?.user?.id;
        final String? dob = data.data?.user?.dob;
        final String? profilePicture = data.data?.user?.pictureUrl;
        final String? followersCount = data.data?.user?.followersCount.toString();

        if (accessToken != null) {
          await localStorageService.set(ATStrings.accessToken, accessToken);
        }
        if (refreshToken != null) {
          await localStorageService.set(ATStrings.refreshToken, refreshToken);
        }
        final CachedUserData cachedUserData = CachedUserData(
            username: userName,
            email: email,
            name: name,
            userId: userId,
            dob: dob,
            followersCount: followersCount);
        await localStorageService.setObject(
          ATStrings.cachedUserData,
          cachedUserData.toJson(),
        );
        emit(SuccessState<ATUser>(
          newData: data.data?.user,
        ));
      }, unSuccessful: (Unsuccessful<LoginResponseModel> error) {
        emit(FailureState<ATUser>(error.error.message));
      });
    } catch (e) {
      emit(FailureState<ATUser>('Unable to login user: $e'));
    }
  }
}
