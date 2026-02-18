import 'dart:developer' show log;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/features/auth/data/models/response/signup_response.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:dio/dio.dart' show Response, MultipartFile;

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<bool>> checkIdentityAvailability({
    required Map<String, dynamic> param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.checkIdentityAvailability,
        data: param,
      );

      final bool status = response.data['status'] ?? false;
      return Successful<bool>(data: status);
    } catch (e) {
      log('Check identity availability error: $e');
      return Unsuccessful<bool>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<String>> sendOtp({
    required Map<String, dynamic> param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.sendOtp,
        data: param,
      );

      final String otp = response.data['data']['otp'] as String;
      return Successful<String>(data: otp);
    } catch (e) {
      log('Send OTP error: $e');
      return Unsuccessful<String>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> verifyOtp({
    required Map<String, dynamic> param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.verifyOtp,
        data: param,
      );

      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Verify OTP error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> loginUser({
    required Map<String, dynamic> param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.login,
        data: param,
      );

      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Unable to log in user: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<SignupResponseModel>> registerUser({
    required RegistrationData param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.register,
        data: param.toJson(),
      );

      final signupResponse = SignupResponseModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      return Successful<SignupResponseModel>(data: signupResponse);
    } catch (e) {
      log('Unable to register user: $e');
      return Unsuccessful<SignupResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> uploadImage({
    required String filePath,
  }) async {
    try {
      final Map<String, dynamic> param = <String, dynamic>{
        'images': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
        'purpose': 'profile-picture',
      };

      final Response<dynamic> response = await networkService.formDataRequest(
        ATEndpoints.uploadImage,
        data: param,
      );

      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Unable to upload image: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

}
