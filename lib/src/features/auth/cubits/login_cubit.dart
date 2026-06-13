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


        if(accessToken != null){
          await localStorageService.set(ATStrings.accessToken, accessToken);
        }
        if(refreshToken != null){
          await localStorageService.set(ATStrings.refreshToken, refreshToken);
        }

        await localStorageService.set(ATStrings.isExistingUser, 'true');
        
        final UserProfileData cachedUserData = UserProfileData(
          username: data.data?.user?.username,
          email: data.data?.user?.email,
          name: data.data?.user?.name,
          userId: data.data?.user?.id,
          dob: data.data?.user?.dob,
          profilePhoto: data.data?.user?.pictureUrl,
          followersCount: data.data?.user?.followersCount,
          phoneNumber: data.data?.user?.phoneNumber,
          subscribersCount: data.data?.user?.subscribersCount,
          followingCount: data.data?.user?.followingCount,
        );
        await localStorageService.setObject(
          ATStrings.cachedUserData,
          cachedUserData.toLocalStorageJson(),
        );
        emit(SuccessState<ATUser>(newData: data.data?.user,));
      },
      unSuccessful: (Unsuccessful<LoginResponseModel> error){
        emit(FailureState<ATUser>(error.error.message));
      }
    );
    } catch (e) {
      emit(FailureState<ATUser>('Unable to login user: $e'));
    }
  }
}
