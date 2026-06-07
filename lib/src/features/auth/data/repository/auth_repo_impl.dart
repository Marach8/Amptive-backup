import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/features/auth/data/models/response/auth_success_response_model.dart';
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
      await networkService.post(
        ATEndpoints.sendOtp,
        data: param,
      );

      return Successful<String>(data: 'otp sent');
    } catch (e) {
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
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<LoginResponseModel>> loginUser({
    required Map<String, dynamic> param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.login,
        data: param,
      );

      final LoginResponseModel loginResponse =
          LoginResponseModel.fromJson(response.data);
      return Successful<LoginResponseModel>(data: loginResponse);
    } catch (e) {
      return Unsuccessful<LoginResponseModel>(
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
      return Unsuccessful<String>(
        error: ATException.resolveException(e));
    }
  }

  @override
  Future<ApiResponse<SignUpResponseModel>> registerUser({
    required RegistrationData param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.register,
        data: param.toJson(),
      );

      final SignUpResponseModel signupResponse =
          SignUpResponseModel.fromJson(response.data['data']);
      return Successful<SignUpResponseModel>(data: signupResponse);
    } catch (e) {
      return Unsuccessful<SignUpResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<String>> uploadImage({
    required String filePath,
    String? purpose,
  }) async {
    try {
      final Map<String, dynamic> param = <String, dynamic>{
        'images': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
        'purpose': purpose ?? 'profile-picture',
      };

      final Response<dynamic> response = 
      await networkService.formDataRequest(
        ATEndpoints.uploadImage,
        data: param,
      );

      final List<dynamic> urls = response.data['data']['urls'];
      final String imageUrl = urls.first;

      return Successful<String>(data: imageUrl);
    } catch (e) {
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
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e));
    }
  }

  @override
  Future<ApiResponse<String>> resetPassword({
    required Map<String, dynamic> param,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.resetPassword,
        data: param,
      );
      final String successMessage = response.data['message'];
      return Successful<String>(data: successMessage);
    } catch (e) {
      return Unsuccessful<String>(
        error: ATException.resolveException(e));
    }
  }
  
  @override
  Future<ApiResponse<bool>> logout() async{
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      return Successful<bool>(data: true);
    } catch (e) {
      return Unsuccessful<bool>(
        error: ATException.resolveException(e),
      );
    }
  }  
}
