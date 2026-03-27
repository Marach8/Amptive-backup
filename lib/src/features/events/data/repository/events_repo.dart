import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/events/data/models/request/create_event_model.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';

abstract class EventsRepo {
  Future<ApiResponse<HostedEvent>> fetchEvent({
    required String eventId,
  });

  Future<ApiResponse<HostedEvent>> createEvent({
    required CreateEventPayload createEventModel,
  });

  Future<ApiResponse<HostedEventsResponseModel>> fetchHostedEvents({
    required int page,
    required int pageSize,
    required bool refresh,
  });

  Future<ApiResponse<HostedEvent>> startEvent({
    required String eventId,
    required String streamUrl,
    required String streamKey,
    required String reason,
  });
}
