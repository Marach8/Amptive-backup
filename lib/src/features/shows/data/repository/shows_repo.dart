import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/shows/data/models/request/create_show_model.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';

abstract class ShowsRepo {
  Future<ApiResponse<HostedShow>> fetchShow({
    required String showId,
  });

  Future<ApiResponse<HostedShow>> createShow({
    required CreateShowPayload createShowModel,
  });

  Future<ApiResponse<HostedShowsResponseModel>> fetchHostedShows({
    required int page,
    required int pageSize,
    required bool refresh,
  });
}
