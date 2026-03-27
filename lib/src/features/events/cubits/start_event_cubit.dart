import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/events/data/repository/events_repo.dart';
import 'package:amptive/src/features/events/data/repository/events_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartEventCubit extends Cubit<ATAppState<HostedEvent>> {
  StartEventCubit({EventsRepo? mockEventsRepo})
      : eventsRepo = mockEventsRepo ?? EventsRepoImpl(),
        super(const InitialState<HostedEvent>());

  final EventsRepo eventsRepo;

  HostedEvent? get currentEventData => switch (state) {
        InitialState<HostedEvent>(:final HostedEvent? initialData) =>
          initialData,
        LoadingState<HostedEvent>(:final HostedEvent? currentData) =>
          currentData,
        SuccessState<HostedEvent>(:final HostedEvent? newData) => newData,
        FailureState<HostedEvent>(:final HostedEvent? oldData) => oldData,
      };

  Future<void> startEvent({
    required String eventId,
    required String streamUrl,
    required String streamKey,
    required String reason,
  }) async {
    emit(LoadingState<HostedEvent>(currentData: currentEventData));
    try {
      final ApiResponse<HostedEvent> response = await eventsRepo.startEvent(
        eventId: eventId,
        streamUrl: streamUrl,
        streamKey: streamKey,
        reason: reason,
      );
      response.when(
        successful: (Successful<HostedEvent> data) {
          emit(SuccessState<HostedEvent>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HostedEvent> error) {
          emit(FailureState<HostedEvent>(error.error.message,
              oldData: currentEventData));
        },
      );
    } catch (e) {
      emit(FailureState<HostedEvent>('Unable to start event: $e',
          oldData: currentEventData));
    }
  }
}
