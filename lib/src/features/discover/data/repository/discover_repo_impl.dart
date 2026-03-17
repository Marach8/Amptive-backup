import 'dart:developer';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/all_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/trending_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:dio/dio.dart';

class DiscoverRepoImpl implements DiscoverRepo {
  DiscoverRepoImpl({
    NetworkService? mockNetworkService,
  }) : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<CommunitiesResponseModel>> fetchCommunities({
    required int pageNo,
    required int pageSize,
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

  @override
  Future<ApiResponse<AllUsersResponseModel>> fetchAllUsers({
    required int page,
    required int pageSize,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.getUsers,
        queryParameters: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
        },
      );
      return Successful<AllUsersResponseModel>(
        data: AllUsersResponseModel.fromJson(response.data),
      );
    } catch (e) {
      log('Error in fetching users');
      return Unsuccessful<AllUsersResponseModel>(
          error: ATException.resolveException(e));
    }
  }

  @override
  Future<ApiResponse<AllHashtagsResponseModel>> fetchHashTags({
    required int page,
    required int pageSize,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        '${ATEndpoints.tags}/hashtags',
        queryParameters: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
        },
      );
      return Successful<AllHashtagsResponseModel>(
        data: AllHashtagsResponseModel.fromJson(response.data),
      );
    } catch (e) {
      log('Error in fetching tags: $e');
      return Unsuccessful<AllHashtagsResponseModel>(
          error: ATException.resolveException(e));
    }
  }

  @override
  Future<ApiResponse<HashTag>> createHashtag({
    required String name,
    required String displayName,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.createHashtag,
        data: <String, dynamic>{
          'name': name,
          'displayName': displayName,
        },
      );
      return Successful<HashTag>(
        data: HashTag.fromJson(response.data),
      );
    } catch (e) {
      log('Error in creating hashtag: $e');
      return Unsuccessful<HashTag>(
          error: ATException.resolveException(e));
    }
  }
  @override
Future<ApiResponse<TrendingTagsResponseModel>> fetchTrendingTags({
  required int limit,
  String? tagType,
}) async {
  try {
    final Response<dynamic> response = await networkService.get(
      ATEndpoints.trendingHashtags,
      queryParameters: <String, dynamic>{
        'limit': limit,
        if (tagType != null) 'tag_type': tagType,
      },
    );
    return Successful<TrendingTagsResponseModel>(
      data: TrendingTagsResponseModel.fromJson(response.data),
    );
  } catch (e) {
   log('Error fetching trending tags: $e');
    return Unsuccessful<TrendingTagsResponseModel>(
      error: ATException.resolveException(e),
    );
  }
}

}
