import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteUserDataCubit extends Cubit<ATAppState<ProfileData>> {
  RemoteUserDataCubit({
    ProfileRepo? mockProfileRepo,
  }) : profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
        super(const InitialState<ProfileData>());

  final ProfileRepo profileRepo;

  Future<void> fetchUserProfile() async {
    emit(const LoadingState<ProfileData>());
    try {
      final ApiResponse<ProfileData> response =
          await profileRepo.fetchUserProfile();

      if(isClosed) return;
      
      response.when(
        successful: (Successful<ProfileData> data) async {
          emit(SuccessState<ProfileData>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<ProfileData> error) {
          emit(FailureState<ProfileData>(error.error.message));
        },
      );
    } catch (_) {
      emit(const FailureState<ProfileData>(
        'Unable to fetch user profile'));
    }
  }


  Future<void> updateRemoteUserProfile({
    required ProfileData userProfileData,
  }) async {
    emit(const LoadingState<ProfileData>());

    try {
      final ApiResponse<ProfileData> response = 
      await profileRepo.updateUserProfile(
        userProfileData: userProfileData,
      );

      response.when(
        successful: (Successful<ProfileData> data) async {
          emit(SuccessState<ProfileData>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<ProfileData> error) {
          emit(FailureState<ProfileData>(error.error.message));
        },
      );
    } catch (_) {
      emit(const FailureState<ProfileData>('Unable to update profile'));
    }
  }
}
