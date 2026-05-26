import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';
import 'package:amptive/src/features/profile/data/models/followers_response_model.dart';

abstract class ProfileRepo{
  Future<ApiResponse<UserProfileResponseModel>> fetchUserProfile ();

  Future<ApiResponse<FollowersResponseModel>> fetchFollowers ({
    required int page,
    required int pageSize,
  });

  Future<ApiResponse<dynamic>> updateUserProfile({  
    String? profilePicture,
    String? name,
    String? username,
    String? bio,
    String? country,
    String? coverPhoto,
    String? xUrl,
    String? instagramUrl,
    String? linkedinUrl,
    String? websiteUrl,


  });

  Future<ApiResponse<String>> sendEmailAndPhoneOtp({
    required Map<String, dynamic> param
});

   
  Future<ApiResponse<dynamic>> verifyOtp({required Map<String, dynamic> param});

  Future<ApiResponse<dynamic>> createProfessionalProfile({
  required String profileType,
  required String category,
  required String subAmount,
  required String coHostFee,
    });  

}
