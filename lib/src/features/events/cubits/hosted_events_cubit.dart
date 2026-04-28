import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/events/data/repository/events_repo.dart';
import 'package:amptive/src/features/events/data/repository/events_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HostedEventsCubit extends Cubit<ATAppState<HostedEventsResponseModel>> {
  HostedEventsCubit({EventsRepo? mockEventsRepo})
      : eventsRepo = mockEventsRepo ?? EventsRepoImpl(),
        super(const InitialState<HostedEventsResponseModel>());

  final EventsRepo eventsRepo;

  HostedEventsResponseModel? get currentHostedEventsData => switch (state) {
        InitialState<HostedEventsResponseModel>(
          :final HostedEventsResponseModel? initialData
        ) =>
          initialData,
        LoadingState<HostedEventsResponseModel>(
          :final HostedEventsResponseModel? currentData
        ) =>
          currentData,
        SuccessState<HostedEventsResponseModel>(
          :final HostedEventsResponseModel? newData
        ) =>
          newData,
        FailureState<HostedEventsResponseModel>(
          :final HostedEventsResponseModel? oldData
        ) =>
          oldData,
      };

  Future<void> fetchHostedEvents([bool forceRefresh = false]) async {
    final bool hasMore = currentHostedEventsData?.hasMore ?? true;
    if (state is LoadingState<HostedEventsResponseModel> || !hasMore) {
      return;
    }

    emit(LoadingState<HostedEventsResponseModel>(
        currentData: currentHostedEventsData));
    try {
      final ApiResponse<HostedEventsResponseModel> response =
          await eventsRepo.fetchHostedEvents(
        page: (currentHostedEventsData?.page ?? 0) + 1,
        pageSize: 20,
        refresh: forceRefresh,
      );
      response.when(
        successful: (Successful<HostedEventsResponseModel> data) {
          final List<HostedEvent>? newHostedEvents = data.data?.hostedEvents;
          final List<HostedEvent> mergedHostedEvents = <HostedEvent>[
            ...?currentHostedEventsData?.hostedEvents,
            ...?newHostedEvents,
          ];

          final HostedEventsResponseModel newData = HostedEventsResponseModel(
            hostedEvents: mergedHostedEvents,
            total: data.data?.total,
            page: data.data?.page,
            pageSize: data.data?.pageSize,
            hasMore: data.data?.hasMore,
          );
          emit(SuccessState<HostedEventsResponseModel>(newData: newData));
        },
        unSuccessful: (Unsuccessful<HostedEventsResponseModel> error) {
          emit(FailureState<HostedEventsResponseModel>(error.error.message,
              oldData: currentHostedEventsData));
        },
      );
    } catch (e) {
      emit(FailureState<HostedEventsResponseModel>('Unable to get events: $e',
          oldData: currentHostedEventsData));
    }
  }

  void addNewHostedEvent(HostedEvent? event) {
    if (event == null) return;
    final List<HostedEvent> updatedEvents = <HostedEvent>[
      event, ...?currentHostedEventsData?.hostedEvents,
    ];

    final HostedEventsResponseModel newData = HostedEventsResponseModel(
      hostedEvents: updatedEvents,
      total: (currentHostedEventsData?.total ?? 0) + 1,
      page: currentHostedEventsData?.page,
      pageSize: currentHostedEventsData?.pageSize,
      hasMore: currentHostedEventsData?.hasMore,
    );

    emit(SuccessState<HostedEventsResponseModel>(newData: newData));
  }


  void updateAnEvent(HostedEvent event) {
    final String? eventId = event.eventId;
    final List<HostedEvent>? currentEvents = currentHostedEventsData?.hostedEvents;
    if (eventId == null || currentEvents == null) return;

    final int eventIndex = currentEvents.indexWhere(
      (HostedEvent element) => element.eventId == eventId);
    if (eventIndex == -1) return;
    final List<HostedEvent> eventsCopy = List<HostedEvent>.from(currentEvents);
    eventsCopy[eventIndex] = event;

    final HostedEventsResponseModel newData = HostedEventsResponseModel(
      hostedEvents: eventsCopy,
      total: (currentHostedEventsData?.total ?? 0),
      page: currentHostedEventsData?.page,
      pageSize: currentHostedEventsData?.pageSize,
      hasMore: currentHostedEventsData?.hasMore,
    );

    emit(SuccessState<HostedEventsResponseModel>(newData: newData));
  }
}
