import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/follow_creator_response_model.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';


abstract class HomeRepo {
  Future<ApiResponse<FollowResponseModel>> followCreator({
    required String targetUserId,
  });

  Future<ApiResponse<FollowResponseModel>> unFollowCreator({
    required String targetUserId,
  });


  Future<ApiResponse<HomeFeedResponseModel>> fetchHomeFeed({
    required int page,
    required int pageSize,
    required bool refresh,
  });

  Future<ApiResponse<dynamic>> fetchFollowedShows({
    required int page,
    required int pageSize,
    required bool refresh,
  });

  Future<ApiResponse<dynamic>> fetchLiveShows({
    required int page,
    required int pageSize,
    required bool refresh,
  });

  Future<ApiResponse<dynamic>> fetchLiveUsers();
}
