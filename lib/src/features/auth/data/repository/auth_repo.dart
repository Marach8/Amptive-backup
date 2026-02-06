import 'package:amptive/src/config/api_response_and_app_state.dart';

abstract class AuthRepo {
  Future<ApiResponse<bool>> checkIdentityAvailability({
    required Map<String, dynamic> param});
}
