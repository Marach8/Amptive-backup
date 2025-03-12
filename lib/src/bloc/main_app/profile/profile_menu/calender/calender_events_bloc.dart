import 'package:flutter_bloc/flutter_bloc.dart';

class CalenderProgramBloc extends Bloc<ProgramsEvents, ProgramsState>{
  CalenderProgramBloc():super(NoProgramsState()){
    on<LoadProgramsEvent>((event, emit)async{
      emit(ProgramsLoadingState());
      try{
        await Future.delayed(const Duration(seconds: 5));
        emit(
          ProgramsDataState(
            programs:{
              '06:00 am': const [
                CalenderProgram(
                  name: 'Former CIA Agent On Trump Assasination Has Repented',
                  id: 1, isEvent: true,
                  isPaid: true
                ),
              ],
              '05:00 pm': const [
                CalenderProgram(
                  name: 'Give Us The Wheel',
                  id: 2, isEvent: false,
                  isPaid: false
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
  final DateTime programDate;
  LoadProgramsEvent({required this.programDate});
}




class CalenderProgram{
  final String name;
  final int id;
  final bool isEvent, isPaid;

  const CalenderProgram({
    required this.name,
    required this.id,
    required this.isEvent,
    required this.isPaid
  });
}