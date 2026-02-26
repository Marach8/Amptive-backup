import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/follow_creator_response_model.dart';

abstract class HomeRepo {
  Future<ApiResponse<FollowResponseModel>> followCreator({
    required String targetUserId,
  });

  Future<ApiResponse<FollowResponseModel>> unFollowCreator({
    required String targetUserId,
  });

}