import 'dart:developer';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:dio/dio.dart';


class DiscoverRepoImpl implements DiscoverRepo {
  DiscoverRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

    @override
  Future<ApiResponse<CommunitiesResponseModel>> fetchCommunities({
    required int pageNo, required int pageSize,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.communities,
        queryParameters: <String, dynamic>{
          'page': pageNo,
          'page_size': pageSize,
        },
      );

      final CommunitiesResponseModel communitiesResponse = 
        CommunitiesResponseModel.fromJson(response.data);
      return Successful<CommunitiesResponseModel>(data: communitiesResponse);
    } catch (e) {
      log('Unable to get communities: $e');
      return Unsuccessful<CommunitiesResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }
}
