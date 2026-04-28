import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/all_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_events_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_shows_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_users_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/unified_search_response_model.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/features/discover/data/models/response/trending_hashtags_response_model.dart';

abstract class DiscoverRepo {
  Future<ApiResponse<CommunitiesResponseModel>> fetchCommunities({
    required int pageNo,
    required int pageSize,
  });

  Future<ApiResponse<AllUsersResponseModel>> fetchAllUsers({
    required int page,
    required int pageSize,
  });

  Future<ApiResponse<AllHashtagsResponseModel>> fetchHashTags({
    required int page,
    required int pageSize,
  });

  Future<ApiResponse<HashTag>> createHashtag({
    required String name,
    required String displayName,
  });
  Future<ApiResponse<TrendingTagsResponseModel>> fetchTrendingTags({
  required int limit,
  String? tagType,
});

  Future<ApiResponse<SearchUsersResponseModel>> searchUsers({
    required String query,
    required int page,
    required int pageSize,
    required String sortBy,
  });

  Future<ApiResponse<UnifiedSearchResponseModel>> unifiedSearch({
    required String query,
    required String sortBy,
  });


  Future<ApiResponse<SearchShowsResponseModel>> searchShows({
    required String query,
    required int page,
    required int pageSize,
    required String sortBy,
    String? category,
    String? status,
    String? showType,
    String? hostId,
  });

  Future<ApiResponse<SearchEventsResponseModel>> searchEvents({
    required String query,
    required int page,
    required int pageSize,
    required String sortBy,
    String? category,
    String? status,
    String? showType,
    String? hostId,
  });

  Future<ApiResponse<SearchHashtagsResponseModel>> searchHashtags({
    required String query,
    required int page,
    required int pageSize,
    required String sortBy,
  });

  Future<ApiResponse<dynamic>> searchSuggestions({
    required String query,
  });


}
