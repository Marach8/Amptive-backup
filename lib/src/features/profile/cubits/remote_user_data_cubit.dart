import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteUserDataCubit extends Cubit<ATAppState<UserData>> {
  RemoteUserDataCubit({
    ProfileRepo? mockProfileRepo,
    ATLocalStorageService? mockLocalStorageService,
  })  : profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
        localStorageService =
            mockLocalStorageService ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<UserData>());

  final ProfileRepo profileRepo;
  final ATLocalStorageService localStorageService;

  Future<void> fetchUserProfile() async {
    emit(const LoadingState<UserData>());
    try {
      final ApiResponse<UserProfileResponseModel> response =
          await profileRepo.fetchUserProfile();

      response.when(
        successful: (Successful<UserProfileResponseModel> data) async {
          final UserData? userData = data.data?.data;

          if (userData != null) {
            final CachedUserData cachedUserData = CachedUserData(
              userId: userData.id,
              email: userData.email,
              username: userData.username,
              dob: userData.dob,
              name: userData.name,
              pictureUrl: userData.pictureUrl,
            );

            await localStorageService.setObject(
              ATStrings.cachedUserData,
              cachedUserData.toJson(),
            );

            emit(SuccessState<UserData>(newData: userData));
          } else {
            emit(const FailureState<UserData>('No user data found'));
          }
        },
        unSuccessful: (Unsuccessful<UserProfileResponseModel> error) {
          emit(FailureState<UserData>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<UserData>('Unable to fetch user profile: $e'));
    }
  }
}
