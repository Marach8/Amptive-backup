import 'dart:developer';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/all_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_events_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_shows_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_users_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/trending_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/unified_search_response_model.dart';
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
    } catch (e, s) {
      log('Error in fetching users: $e $s');
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

@override
Future<ApiResponse<SearchUsersResponseModel>> searchUsers({
  required String query,
  required int page,
  required int pageSize,
  required String sortBy,
}) async {
  try {
    final Response<dynamic> response = await networkService.get(
      ATEndpoints.searchUsers,
      queryParameters: <String, dynamic>{
        'q': query,
        'page': page,
        'page_size': pageSize,
        'sort_by': sortBy,
      },
    );
    return Successful<SearchUsersResponseModel>(
      data: SearchUsersResponseModel.fromJson(response.data),
    );
  } catch (e) {
    log('Error fetching users: $e');
    return Unsuccessful<SearchUsersResponseModel>(
      error: ATException.resolveException(e),
    );
  }
}

@override
Future<ApiResponse<UnifiedSearchResponseModel>> unifiedSearch({
  required String query,
  required String sortBy,
}) async {
  try {
    final Response<dynamic> response = await networkService.get(
      ATEndpoints.unifiedSearch,
      queryParameters: <String, dynamic>{
        'q': query,
        'sort_by': sortBy,
      },
    );
    return Successful<UnifiedSearchResponseModel>(
      data: UnifiedSearchResponseModel.fromJson(response.data),
    );
  } catch (e) {
    log('Error in unified search: $e');
    return Unsuccessful<UnifiedSearchResponseModel>(
      error: ATException.resolveException(e),
    );
  }
}

@override
Future<ApiResponse<SearchHashtagsResponseModel>> searchHashtags({
  required String query,
  required int page,
  required int pageSize,
  required String sortBy,
}) async {
  try {
    final Response<dynamic> response = await networkService.get(
      ATEndpoints.searchHashtags,
      queryParameters: <String, dynamic>{
        'q': query,
        'page': page,
        'page_size': pageSize,
        'sort_by': sortBy,
      },
    );
    return Successful<SearchHashtagsResponseModel>(
      data: SearchHashtagsResponseModel.fromJson(response.data),
    );
  } catch (e) {
    log('Error fetching hashtags: $e');
    return Unsuccessful<SearchHashtagsResponseModel>(
      error: ATException.resolveException(e),
    );
  }
}

@override
Future<ApiResponse<SearchShowsResponseModel>> searchShows({
  required String query,
  required int page,
  required int pageSize,
  required String sortBy,
  String? category,
  String? status,
  String? showType,
  String? hostId,
}) async {
  try {
    final Response<dynamic> response = await networkService.get(
      ATEndpoints.searchShows,
      queryParameters: <String, dynamic>{
        'q': query,
        'page': page,
        'page_size': pageSize,
        'sort_by': sortBy,
        if (category != null && category.isNotEmpty) 'category': category,
        if (status != null && status.isNotEmpty) 'status': status,
        if (showType != null && showType.isNotEmpty) 'show_type': showType,
        if (hostId != null && hostId.isNotEmpty) 'host_id': hostId,
      },
      

    );
    return Successful<SearchShowsResponseModel>(
      data: SearchShowsResponseModel.fromJson(response.data),
    );
  } catch (e) {
    log('Error searching shows: $e');
    return Unsuccessful<SearchShowsResponseModel>(
      error: ATException.resolveException(e),
    );
  }


}
@override
Future<ApiResponse<SearchEventsResponseModel>> searchEvents({
  required String query,
  required int page,
  required int pageSize,
  required String sortBy,
  String? category,
  String? status,
  String? showType,
  String? hostId,
}) async {
  try {
    final Response<dynamic> response = await networkService.get(
      ATEndpoints.searchEvents,
      queryParameters: <String, dynamic>{
        'q': query,
        'page': page,
        'page_size': pageSize,
        'sort_by': sortBy,
        // if (category != null && category.isNotEmpty) 'category': category,
        // if (status != null && status.isNotEmpty) 'status': status,
        // if (showType != null && showType.isNotEmpty) 'show_type': showType,
        // if (hostId != null && hostId.isNotEmpty) 'host_id': hostId,
      },
      

    );
    return Successful<SearchEventsResponseModel>(
      data:SearchEventsResponseModel.fromJson(response.data),
    );
  } catch (e) {
    log('Error searching events: $e');
    return Unsuccessful<SearchEventsResponseModel>(
      error: ATException.resolveException(e),
    );
  }

}

@override
Future<ApiResponse<dynamic>> searchSuggestions({
  required String query,
}) async {
  try {
    final Response<dynamic> response = await networkService.get(
      ATEndpoints.searchSuggestions,
      queryParameters: <String, dynamic>{
        'q': query,
      },
    );
    return Successful<dynamic>(
      data:(response.data),
    );
  } catch (e) {
    log('Error fetching search suggestions: $e');
    return Unsuccessful<dynamic>(
      error: ATException.resolveException(e),
    );
  }
}
}
