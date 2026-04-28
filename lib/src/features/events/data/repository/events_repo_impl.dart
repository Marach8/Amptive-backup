import 'dart:developer' show log;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/events/data/models/request/create_event_model.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/events/data/repository/events_repo.dart';
import 'package:dio/dio.dart' show Response;

class EventsRepoImpl implements EventsRepo {
  EventsRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();

  final NetworkService networkService;

  @override
  Future<ApiResponse<HostedEvent>> fetchEvent({
    required String eventId,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        '${ATEndpoints.events}$eventId',
      );

      final HostedEvent eventResponse = HostedEvent.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Successful<HostedEvent>(data: eventResponse);
    } catch (e) {
      log('Fetch event error: $e');
      return Unsuccessful<HostedEvent>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<HostedEvent>> createEvent({
    required CreateEventPayload createEventModel,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.events,
        data: createEventModel.toJson(),
      );

      final HostedEvent eventResponse = HostedEvent.fromJson(
        response.data,
      );
      return Successful<HostedEvent>(data: eventResponse);
    } catch (e) {
      log('Create event error: $e');
      return Unsuccessful<HostedEvent>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<HostedEvent>> updateEvent({
    required String eventId,
    required CreateEventPayload createEventModel,
  }) async {
    try {
      final Response<dynamic> response = await networkService.patch(
        '${ATEndpoints.events}$eventId',
        data: createEventModel.toJson(),
      );

      final HostedEvent eventResponse = HostedEvent.fromJson(
        response.data,
      );
      return Successful<HostedEvent>(data: eventResponse);
    } catch (e) {
      log('Update event error: $e');
      return Unsuccessful<HostedEvent>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<HostedEventsResponseModel>> fetchHostedEvents({
    required int page,
    required int pageSize,
    required bool refresh,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        '${ATEndpoints.events}me/',
        queryParameters: <String, dynamic>{
          'page': page,
          'page_size': pageSize,
          'refresh': refresh,
        },
      );

      final HostedEventsResponseModel hostedEventsResponse =
          HostedEventsResponseModel.fromJson(
        response.data
      );
      return Successful<HostedEventsResponseModel>(data: hostedEventsResponse);
    } catch (e) {
      log('Get events error: $e');
      return Unsuccessful<HostedEventsResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }

  @override
  Future<ApiResponse<HostedEvent>> startEvent({
    required String eventId,
    required String streamUrl,
    required String streamKey,
    required String reason,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        '${ATEndpoints.events}$eventId/start',
        data: <String, dynamic>{
          'stream_url': streamUrl,
          'stream_key': streamKey,
          'reason': reason,
        },
      );

      final HostedEvent eventResponse = HostedEvent.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Successful<HostedEvent>(data: eventResponse);
    } catch (e) {
      log('Start event error: $e');
      return Unsuccessful<HostedEvent>(
        error: ATException.resolveException(e),
      );
    }
  }
}
