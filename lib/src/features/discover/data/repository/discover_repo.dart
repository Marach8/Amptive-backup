import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';

abstract class DiscoverRepo {
  Future<ApiResponse<CommunitiesResponseModel>> fetchCommunities({
    required int pageNo, required int pageSize,
  });  
}
