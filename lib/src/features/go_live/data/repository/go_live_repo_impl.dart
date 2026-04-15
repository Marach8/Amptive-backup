import 'dart:developer' show log;
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';

class GoLiveRepoImpl implements GoLiveRepo {
  GoLiveRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<dynamic>> startLiveProgram(
    {required String contentId}) async {
    try {
      final response = await networkService.post(
        '${ATEndpoints.livestreams}$contentId/start',
        data: <String, dynamic>{},
      );
      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Start live program error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> endLiveProgram(
    {required String livestreamId}) async {
    try {
      final response = await networkService.post(
        '${ATEndpoints.livestreams}$livestreamId/end',
        data: <String, dynamic>{},
      );
      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('End live program error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> reactToLiveProgram(
    {required String livestreamId}) async {
    try {
      final response = await networkService.post(
        '${ATEndpoints.livestreams}$livestreamId/react',
        data: <String, dynamic>{},
      );
      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('React to live program error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> getLiveProgramEntryToken(
    {required String livestreamId}) async {
    try {
      final response = await networkService.post(
        '${ATEndpoints.livestreams}$livestreamId/token',
        data: <String, dynamic>{},
      );
      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Get live program entry token error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }
}
