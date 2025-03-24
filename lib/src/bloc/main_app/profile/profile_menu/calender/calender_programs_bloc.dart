import 'package:amptive/src/models/host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../services/go_live_service/go_live_service.dart';

class CalenderProgramBloc extends Bloc<ProgramsEvents, ProgramsState>{
  CalenderProgramBloc():super(NoProgramsState()){
    on<LoadProgramsEvent>((event, emit)async{
      emit(ProgramsLoadingState());
      try{
        await Future.delayed(const Duration(seconds: 5));
        emit(
          ProgramsDataState(
            programs:{
              '06:00 am': [
                CalenderProgram(
                  name: 'Former CIA Agent On Trump Assasination Has Repented',
                  id: 1, isEvent: true,
                  isPaid: true, dateTime: event.programDate,
                  eventType: 'News',
                  hosts: getHostList().take(2).toList()
                ),
                CalenderProgram(
                  name: 'Config 2024',
                  id: 1, isEvent: true,
                  isPaid: true, dateTime: event.programDate,
                  eventType: 'Comedy',
                  hosts: getHostList().take(1).toList()
                ),
                CalenderProgram(
                  name: 'Dont Forget Who You are',
                  id: 1, isEvent: true,
                  isPaid: false, dateTime: event.programDate,
                  eventType: 'News',
                  hosts: getHostList().take(5).toList()
                ),
              ],
              '05:00 pm': [
                CalenderProgram(
                  name: 'Give Us The Wheel',
                  id: 2, isEvent: false,
                  isPaid: false, dateTime: event.programDate,
                  eventType: 'Comedy',
                  hosts: getHostList().take(4).toList()
                ),
              ]
            }
          )
        );
      }
      catch (_){
        emit(ProgramsErrorState());
      }
    });

  }
}


abstract class ProgramsState{}

class NoProgramsState extends ProgramsState{}
class ProgramsLoadingState extends ProgramsState{}
class ProgramsDataState extends ProgramsState{
  final Map<String, List<CalenderProgram>> programs;
  ProgramsDataState({required this.programs});
}

class ProgramsErrorState extends ProgramsState{}


abstract class ProgramsEvents{}

class LoadProgramsEvent extends ProgramsEvents{
  final DateTime? programDate;
  LoadProgramsEvent({required this.programDate});
}




class CalenderProgram{
  final String name, eventType;
  final int id;
  final List<ObjectWithNotifier> hosts;
  final bool isEvent, isPaid;
  final DateTime? dateTime;

  const CalenderProgram({
    required this.name,
    required this.id,
    required this.isEvent,
    required this.isPaid,
    required this.eventType,
    required this.hosts,
    required this.dateTime
  });
}