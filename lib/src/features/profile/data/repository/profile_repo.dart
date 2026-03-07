import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';

abstract class ProfileRepo {
  Future<ApiResponse<UserProfileResponseModel>> fetchUserProfile();

  Future<ApiResponse<dynamic>> updateUserProfile({
    required String profilePicture,
  });
}
