
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
        AEEndpoints.checkIdentityAvailability,
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
}
