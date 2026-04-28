import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/events/data/repository/events_repo.dart';
import 'package:amptive/src/features/events/data/repository/events_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailCubit extends Cubit<ATAppState<HostedEvent>> {
  EventDetailCubit({
    EventsRepo? mockEventsRepo,
    required HostedEvent initialEvent,
  })  : eventsRepo = mockEventsRepo ?? EventsRepoImpl(),
        super(InitialState<HostedEvent>(initialData: initialEvent));

  final EventsRepo eventsRepo;

  HostedEvent? get currentEventDetail => switch (state) {
    InitialState<HostedEvent>(:final HostedEvent? initialData) => initialData,
    LoadingState<HostedEvent>(:final HostedEvent? currentData) => currentData,
    SuccessState<HostedEvent>(:final HostedEvent? newData) => newData,
    FailureState<HostedEvent>(:final HostedEvent? oldData) => oldData,
  };

  Future<void> fetchEventDetails() async {
    if (state is LoadingState<HostedEvent>) return;
    emit(LoadingState<HostedEvent>(currentData: currentEventDetail));
    try {
      final ApiResponse<HostedEvent> response =
          await eventsRepo.fetchEvent(
        eventId: currentEventDetail?.eventId ?? '',
      );

      response.when(
        successful: (Successful<HostedEvent> data) {
          emit(SuccessState<HostedEvent>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HostedEvent> error) {
          emit(
            FailureState<HostedEvent>(
              error.error.message,
              oldData: currentEventDetail,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<HostedEvent>(
          'Unable to fetch event: $e',
          oldData: currentEventDetail,
        ),
      );
    }
  }


  void updateEvent(HostedEvent newEvent){
    emit(SuccessState<HostedEvent>(newData: newEvent));
  }
}
