import 'dart:developer' show log;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/go_live/data/models/request/create_show_model.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:dio/dio.dart' show Response;

class GoLiveRepoImpl implements GoLiveRepo {
  GoLiveRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<dynamic>> createShow({
    required CreateShowModel createShowModel,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.shows,
        data: createShowModel.toJson(),
      );

      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('Create show error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }
}
