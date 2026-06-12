import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteUserDataCubit extends Cubit<ATAppState<UserProfileData>> {
  RemoteUserDataCubit({
    ProfileRepo? mockProfileRepo,
  }) : profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
        super(const InitialState<UserProfileData>());

  final ProfileRepo profileRepo;

  Future<void> fetchUserProfile() async {
    emit(const LoadingState<UserProfileData>());
    try {
      final ApiResponse<UserProfileData> response =
          await profileRepo.fetchUserProfile();

      if(isClosed) return;
      
      response.when(
        successful: (Successful<UserProfileData> data) async {
          emit(SuccessState<UserProfileData>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<UserProfileData> error) {
          emit(FailureState<UserProfileData>(error.error.message));
        },
      );
    } catch (_) {
      emit(const FailureState<UserProfileData>(
        'Unable to fetch user profile'));
    }
  }


  Future<void> updateRemoteUserProfile({
    required UserProfileData userProfileData,
  }) async {
    emit(const LoadingState<UserProfileData>());

    try {
      final ApiResponse<UserProfileData> response = 
      await profileRepo.updateUserProfile(
        userProfileData: userProfileData,
      );

      response.when(
        successful: (Successful<UserProfileData> data) async {
          emit(SuccessState<UserProfileData>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<UserProfileData> error) {
          emit(FailureState<UserProfileData>(error.error.message));
        },
      );
    } catch (_) {
      emit(const FailureState<UserProfileData>('Unable to update profile'));
    }
  }
}
