import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/events/data/models/request/create_event_model.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/events/data/repository/events_repo.dart';
import 'package:amptive/src/features/events/data/repository/events_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventCubit extends Cubit<ATAppState<HostedEvent>> {
  CreateEventCubit({EventsRepo? mockEventsRepo})
      : eventsRepo = mockEventsRepo ?? EventsRepoImpl(),
        super(const InitialState<HostedEvent>());

  final EventsRepo eventsRepo;

  Future<void> createEvent({
    required CreateEventPayload createEventModel}) async {
    emit(const LoadingState<HostedEvent>());
    try {

      final ApiResponse<HostedEvent> response = await eventsRepo.createEvent(
        createEventModel: createEventModel,
      );
      response.when(
        successful: (Successful<HostedEvent> data) {
          emit(SuccessState<HostedEvent>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HostedEvent> error) {
          emit(FailureState<HostedEvent>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<HostedEvent>('Unable to create event: $e'));
    }
  }
}
