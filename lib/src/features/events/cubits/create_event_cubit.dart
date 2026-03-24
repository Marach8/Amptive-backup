import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/events/data/models/request/create_event_model.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/events/data/repository/events_repo.dart';
import 'package:amptive/src/features/events/data/repository/events_repo_impl.dart';
import 'package:amptive/src/features/shows/data/models/request/create_show_model.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventCubit extends Cubit<ATAppState<HostedEvent>> {
  CreateEventCubit({EventsRepo? mockEventsRepo})
      : eventsRepo = mockEventsRepo ?? EventsRepoImpl(),
        super(const InitialState<HostedEvent>());

  final EventsRepo eventsRepo;

  Future<void> createEvent({
    required String title,
    required String description,
    required String coverUrl,
    required String category,
    required String showType,
    required double price,
    required List<String> tagIds,
    required List<String> coHostIds,
    required String communityId,
    required bool allowHandRaising,
  }) async {
    emit(const LoadingState<HostedEvent>());
    try {
      final CreateEventPayload createEventModel = CreateEventPayload(
        title: title,
        description: description,
        coverUrl: coverUrl,
        category: category,
        eventType: showType,
        price: price,
        tagIds: tagIds,
        coHostIds: coHostIds,
        communityId: communityId,
      );

      final ApiResponse<HostedEvent> response = await eventsRepo.createEvent(
        createEventModel: createEventModel,
      );
      response.when(
        successful: (Successful<HostedShow> data) {
          emit(SuccessState<HostedShow>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HostedShow> error) {
          emit(FailureState<HostedShow>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<HostedShow>('Unable to create show: $e'));
    }
  }
}
