import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/data/models/request/create_show_model.dart';

abstract class GoLiveRepo {
  Future<ApiResponse<dynamic>> createShow({
    required CreateShowModel createShowModel,
  });
}
