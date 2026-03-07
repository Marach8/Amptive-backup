import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentRecipientsBloc
    extends Bloc<RecentRecipientsEvents, RecentRecipientsState> {
  RecentRecipientsBloc() : super(RecentRecipientsInitial()) {
    on<SearchRecentRecipients>((SearchRecentRecipients event,
        Emitter<RecentRecipientsState> emit) async {
      if (event.query.isEmpty) {
        emit(RecentRecipientsInitial());
        return;
      }

      emit(RecentRecipientsLoading());
      await Future.delayed(const Duration(seconds: 3));
      final List<ObjectWithNotifier<Host>> searchResult = getHostList()
          .where((ObjectWithNotifier<Host> host) => (host.obj.name ?? '')
              .toLowerCase()
              .contains(event.query.toLowerCase()))
          .toList();

      if (searchResult.isEmpty) {
        emit(RecentRecipientsInitial());
        return;
      }

      emit(RecentRecipientsData(
          recipients: searchResult, selectedRecipient: null));
    });

    on<SelectRecipient>(
        (SelectRecipient event, Emitter<RecentRecipientsState> emit) async {
      if (state is RecentRecipientsData) {
        final RecentRecipientsData currentState = state as RecentRecipientsData;
        emit(RecentRecipientsData(
            recipients: currentState.recipients,
            selectedRecipient: event.recipient));
      }
    });

    on<ResetRecipientsEvent>((_, Emitter<RecentRecipientsState> emit) {
      emit(RecentRecipientsInitial());
    });
  }
}

abstract class RecentRecipientsState {}

class RecentRecipientsInitial extends RecentRecipientsState {}

class RecentRecipientsLoading extends RecentRecipientsState {}

class RecentRecipientsData extends RecentRecipientsState {
  RecentRecipientsData(
      {required this.recipients, required this.selectedRecipient});
  final List<ObjectWithNotifier<Host>> recipients;
  final ObjectWithNotifier<Host>? selectedRecipient;
}

abstract class RecentRecipientsEvents {}

class SearchRecentRecipients extends RecentRecipientsEvents {
  SearchRecentRecipients(this.query);
  final String query;
}

class SelectRecipient extends RecentRecipientsEvents {
  SelectRecipient(this.recipient);
  final ObjectWithNotifier<Host> recipient;
}

class ResetRecipientsEvent extends RecentRecipientsEvents {}
