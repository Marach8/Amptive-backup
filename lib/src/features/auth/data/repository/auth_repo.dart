import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/features/auth/data/models/response/auth_success_response_model.dart';

abstract class AuthRepo {
  Future<ApiResponse<bool>> checkIdentityAvailability(
      {required Map<String, dynamic> param});

  Future<ApiResponse<String>> sendOtp({required Map<String, dynamic> param});

  Future<ApiResponse<dynamic>> verifyOtp({required Map<String, dynamic> param});

  Future<ApiResponse<LoginResponseModel>> loginUser(
      {required Map<String, dynamic> param});

  Future<ApiResponse<String>> resetPasswordOtp(
      {required Map<String, dynamic> param});

  Future<ApiResponse<dynamic>> verifyResetPasswordOtp(
      {required Map<String, dynamic> param});

  Future<ApiResponse<SignUpResponseModel>> registerUser(
      {required RegistrationData param});

  Future<ApiResponse<String>> uploadImage({
    required String filePath,
    String? purpose,
  });

  Future<ApiResponse<String>> resetPassword(
      {required Map<String, dynamic> param});


}
