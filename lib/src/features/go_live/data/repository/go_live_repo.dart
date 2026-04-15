
import 'package:amptive/src/config/api_response_and_app_state.dart';

abstract class GoLiveRepo {
  Future<ApiResponse<dynamic>> startLiveProgram({required String contentId});

  Future<ApiResponse<dynamic>> endLiveProgram({required String livestreamId});

  Future<ApiResponse<dynamic>> reactToLiveProgram({required String livestreamId});
  
  Future<ApiResponse<dynamic>> getLiveProgramEntryToken({required String livestreamId});
}
