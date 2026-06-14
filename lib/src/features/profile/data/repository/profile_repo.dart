import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/data/models/followers_response_model.dart';
import 'package:amptive/src/features/profile/data/models/request/create_professional_profile_request.dart';

abstract class ProfileRepo{
  Future<ApiResponse<ProfileData>> fetchUserProfile ();

  Future<ApiResponse<FollowersResponseModel>> fetchFollowers ({
    required int page,
    required int pageSize,
  });

  Future<ApiResponse<ProfileData>> updateUserProfile({
    required ProfileData userProfileData,
  });

  Future<ApiResponse<String>> sendEmailAndPhoneOtp({
    required Map<String, dynamic> param
  });

   
  Future<ApiResponse<dynamic>> verifyOtp({required Map<String, dynamic> param});

  Future<ApiResponse<dynamic>> createProfessionalProfile({
    required UpgradeProfileData param,
  });
}
