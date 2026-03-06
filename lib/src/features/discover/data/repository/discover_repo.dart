import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/get_all_users_response_model.dart';

abstract class DiscoverRepo {
  Future<ApiResponse<GetAllUsersResponseModel>> fetchAllUsers({
    required int page,
    required int pageSize,
  });

  
}
