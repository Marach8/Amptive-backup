import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<ATAppState<ProfileData>> {
  LoginCubit(
      {AuthRepo? mockAuthRepo, ATLocalStorageService? mockLocalStorageService})
      : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        localStorageService =
            mockLocalStorageService ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<ProfileData>());

  final AuthRepo authRepo;
  final ATLocalStorageService localStorageService;

  Future<void> loginUser({required Map<String, dynamic> param}) async {
    emit(const LoadingState<ProfileData>());
    
    try {
      final ApiResponse<dynamic> response =
          await authRepo.loginUser(param: param);
      response.when(successful: (Successful<dynamic> data) async {
        final String? accessToken = data.data['data']?['access_token'];
        final String? refreshToken = data.data['data']?['refresh_token'];

        if(accessToken != null){
          await localStorageService.set(ATStrings.accessToken, accessToken);
        }
        if(refreshToken != null){
          await localStorageService.set(ATStrings.refreshToken, refreshToken);
        }

        await localStorageService.set(ATStrings.isExistingUser, 'true');
        
        final ProfileData userProfileData = 
          ProfileData.fromRemoteJson(data.data['data']['user']);

        await localStorageService.setObject(
          ATStrings.cachedUserData,
          userProfileData.toLocalStorageJson(),
        );
        emit(SuccessState<ProfileData>(newData: userProfileData));
      },
      unSuccessful: (Unsuccessful<dynamic> error){
        emit(FailureState<ProfileData>(error.error.message));
      }
      );
    } catch (e) {
      emit(FailureState<ProfileData>('Unable to login user: $e'));
    }
  }
}
