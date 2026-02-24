import 'package:amptive/src/config/api_response_and_app_state.dart';

abstract class HomeRepo {
  Future<ApiResponse<dynamic>> fetchHomeFeed({
    required int page,
    required int pageSize,
    required bool refresh,
  });
}
