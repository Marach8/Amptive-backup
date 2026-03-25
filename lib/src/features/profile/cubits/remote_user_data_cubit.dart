import 'dart:io';
import 'dart:typed_data';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class RemoteUserDataCubit extends Cubit<ATAppState<UserData>> {
  RemoteUserDataCubit({
    ProfileRepo? mockProfileRepo,
    ATLocalStorageService? mockLocalStorageService,
    AuthRepo? mockAuthRepo,
  })  : profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
        localStorageService =
            mockLocalStorageService ?? FlutterSecureStorageServiceImpl(),
        authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<UserData>());

  final ProfileRepo profileRepo;
  final ATLocalStorageService localStorageService;
  final AuthRepo authRepo;

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
              bio: userData.bio,
              phoneNumber: userData.phoneNumber,
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

 Future<void> updateProfile({
  Uint8List? imageBytes,
  String? name,
  String? username,
  String? bio,
  String? country,
  String? coverPhoto,
  String? xUrl,
  String? instagramUrl,
  String? linkedinUrl,
  String? websiteUrl,
}) async {
  try {
    String? imageUrl;

    if (imageBytes != null) {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.png';

      final File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      final ApiResponse<String> uploadResponse =
          await authRepo.uploadImage(filePath: file.path);

      await uploadResponse.when(
        successful: (Successful<String> uploadData) async {
          imageUrl = uploadData.data!;
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<UserData>(error.error.message));
          return; // Exit early if upload fails
        },
      );

      if (await file.exists()) {
        await file.delete();
      }
    }

    final ApiResponse<dynamic> response =
        await profileRepo.updateUserProfile(
      profilePicture: imageUrl,
      name: name,
      username: username,
      bio: bio,
      country: country,
      coverPhoto: coverPhoto,
      xUrl: xUrl,
      instagramUrl: instagramUrl,
      linkedinUrl: linkedinUrl,
      websiteUrl: websiteUrl,
      
    );

    response.when(
      successful: (_) async {
        await fetchUserProfile();
      },
      unSuccessful: (Unsuccessful<dynamic> error) {
        emit(FailureState<UserData>(error.error.message));
      },
    );
  } catch (e) {
    emit(FailureState<UserData>('Unable to update profile: $e'));
  }
}

}
