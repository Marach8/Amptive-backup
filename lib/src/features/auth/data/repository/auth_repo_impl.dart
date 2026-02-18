import 'dart:developer' show log;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:dio/dio.dart' show Response;

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
  Future<ApiResponse<String>> resetPasswordOtp({
    required Map<String, dynamic> param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.resetPasswordOtp,
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
  Future<ApiResponse<dynamic>> verifyResetPasswordOtp({
    required Map<String, dynamic> param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.verifyresetPasswordOtp,
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
}
