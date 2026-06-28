import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/cubits/get_live_program_entry_token_cubit.dart';

abstract class GoLiveRepo {
  Future<ApiResponse<LiveProgramEntryToken>> 
    startLiveProgram({required String contentId});

  Future<ApiResponse<bool>> endLiveProgram({required String livestreamId});

  Future<ApiResponse<dynamic>> reactToLiveProgram({required String livestreamId});
  
  Future<ApiResponse<LiveProgramEntryToken>> getLiveProgramEntryToken({required String livestreamId});
}
