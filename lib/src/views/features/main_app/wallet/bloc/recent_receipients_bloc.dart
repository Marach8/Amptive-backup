import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentRecipientsBloc extends Bloc<RecentRecipientsEvents, RecentRecipientsState>{
  RecentRecipientsBloc() : super(RecentRecipientsInitial()){
    on<SearchRecentRecipients>((event, emit)async{
      if(event.query.isEmpty){
        emit(RecentRecipientsInitial());
        return;
      }

      emit(RecentRecipientsLoading());
      await Future.delayed(const Duration(seconds: 3));
      final searchResult = getHostList().where(
        (host) => (host.obj.name ?? '').toLowerCase().contains(event.query.toLowerCase())
      ).toList();
      
      if(searchResult.isEmpty){
        emit(RecentRecipientsInitial());
        return;
      }

      emit(
        RecentRecipientsData(
          recipients: searchResult,
          selectedRecipient: null
        )
      );
    });

    on<SelectRecipient>((event, emit)async{
      if(state is RecentRecipientsData){
        final currentState = state as RecentRecipientsData;
        emit(
          RecentRecipientsData(
            recipients: currentState.recipients,
            selectedRecipient: event.recipient
          )
        );
      }
    });

    on<ResetRecipientsEvent>((_, emit){
      emit(RecentRecipientsInitial());
    });
  }
}


abstract class RecentRecipientsState{}

class RecentRecipientsInitial extends RecentRecipientsState{}

class RecentRecipientsLoading extends RecentRecipientsState{}

class RecentRecipientsData extends RecentRecipientsState{
  final List<ObjectWithNotifier<Host>> recipients;
  final ObjectWithNotifier<Host>? selectedRecipient;
  RecentRecipientsData({
    required this.recipients,
    required this.selectedRecipient
  });
}



abstract class RecentRecipientsEvents{}

class SearchRecentRecipients extends RecentRecipientsEvents{
  final String query;
  SearchRecentRecipients(this.query);
}

class SelectRecipient extends RecentRecipientsEvents{
  final ObjectWithNotifier<Host> recipient;
  SelectRecipient(this.recipient);
}

class ResetRecipientsEvent extends RecentRecipientsEvents{}