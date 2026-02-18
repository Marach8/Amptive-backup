import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/features/auth/data/models/response/signup_response.dart';

abstract class AuthRepo {
  Future<ApiResponse<bool>> checkIdentityAvailability({
    required Map<String, dynamic> param});

  Future<ApiResponse<String>> sendOtp({
    required Map<String, dynamic> param});

  Future<ApiResponse<dynamic>> verifyOtp({
    required Map<String, dynamic> param});

  Future<ApiResponse<dynamic>> loginUser({
    required Map<String, dynamic> param
    });

  Future<ApiResponse<SignupResponseModel>> registerUser({
    required RegistrationData param
  });

  Future<ApiResponse<dynamic>> uploadImage({
    required String filePath,
  });
}
