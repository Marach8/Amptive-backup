import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_hosted_show.dart';

abstract class HomeRepo {
  Future<ApiResponse<dynamic>> fetchHomeFeed({
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
}
