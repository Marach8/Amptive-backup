import 'dart:developer' show log;
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/go_live/cubits/get_live_program_entry_token_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/start_live_program_cubit.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/global_export.dart';
import 'package:dio/dio.dart';

class GoLiveRepoImpl implements GoLiveRepo {
  GoLiveRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<StartLiveProgramState>> startLiveProgram(
    {required String contentId}) async {
    try {
      final Response<dynamic> response = await networkService.post(
        '${ATEndpoints.livestreams}$contentId/start',
      );
      
      final StartLiveProgramState state = (
        liveProgramId: response.data['data']['livestream_id'],
        starterToken: response.data['data']['starter_token'],
      );
      return Successful<StartLiveProgramState>(data: state);
    } catch (e) {
      log('Start live program error: $e');
      return Unsuccessful<StartLiveProgramState>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<bool>> endLiveProgram(
    {required String livestreamId}) async {
    try {
      await networkService.post(
        '${ATEndpoints.livestreams}$livestreamId/end',
      );
      return Successful<bool>(data: true);
    } catch (e) {
      log('End live program error: $e');
      return Unsuccessful<bool>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> reactToLiveProgram(
    {required String livestreamId}) async {
    try {
      final response = await networkService.post(
        '${ATEndpoints.livestreams}$livestreamId/react',
        data: <String, dynamic>{},
      );
      return Successful<dynamic>(data: response.data);
    } catch (e) {
      log('React to live program error: $e');
      return Unsuccessful<dynamic>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<LiveProgramEntryToken>> getLiveProgramEntryToken(
    {required String livestreamId}) async {
    try {
      final Response<dynamic> response = await networkService.post(
        '${ATEndpoints.livestreams}$livestreamId/token',
      );

      final dynamic tokenData = response.data;
      final LiveProgramEntryToken entryToken = (
        roomEntryToken: tokenData['token'],
        roomUrl: tokenData['livekit_url'],
        streamId: tokenData['room'],
        roomParticipantId: tokenData['identity'],
      );

      return Successful<LiveProgramEntryToken>(data: entryToken);
    } catch (e) {
      log('Get live program entry token error: $e');
      return Unsuccessful<LiveProgramEntryToken>(
        error: ATException.resolveException(e),
      );
    }
  }
}
