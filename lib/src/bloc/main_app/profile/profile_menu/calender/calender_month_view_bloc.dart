import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_programs_bloc.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CalenderMonthViewBloc extends Bloc<CalenderMonthViewEvent, CalenderMonthViewState>{
  CalenderMonthViewBloc(): super(
    InitialCalenderMonthViewState()
  ){
    const chunkSize = 4;
    int noOfChunksFetched = 0;
    bool hasMoreData = true;
    const currentYear = 2025;

    on<LoadInitialCalenderDataEvent>((_, emit)async{
      hasMoreData = true;
      emit(CalenderMonthViewLoadingState());
      final result = <String, List<List<Map<DateTime?, List<CalenderProgram>>>>>{};
      try{
        for (int month = 1; month <= chunkSize; month++) {
          final monthData = await compute(
            ATHelperFuncs.generateCalendarData,
            [currentYear, month],
          );
          final treatedMonthData = await compute(
            ATHelperFuncs.transformDateTimes2Programs,
            [monthData, 'Give it await', true]
          );
          result.addAll(treatedMonthData);
        }

        emit(
          CalenderMonthViewDataState(
            calenderData: Map<String, List<List<Map<DateTime?, List<CalenderProgram>>>>>.from(result),
            hasMoreData: hasMoreData,
            isLoadingMore: false
          )
        );
        noOfChunksFetched = 1;
        result.clear();
      }
      catch (_){
        emit(CalenderMonthViewErrorState());
      }
    });


    on<LoadMoreCalenderDataEvent>((_, emit)async{
      if(!hasMoreData) return;

      final dataState = (state as CalenderMonthViewDataState);
      if(dataState.isLoadingMore) return;

      emit(
        CalenderMonthViewDataState(
          calenderData: dataState.calenderData,
          hasMoreData: hasMoreData,
          isLoadingMore: true
        )
      );

      try {
        final startMonth = noOfChunksFetched * chunkSize + 1;
        final endMonth = startMonth + chunkSize - 1;

        final newCalenderData = Map<String, List<List<Map<DateTime?, List<CalenderProgram>>>>>.from(dataState.calenderData);

        for (int month = startMonth; month <= endMonth; month++) {
          if (month > 12) {
            hasMoreData = false;
            break;
          }

          final monthData = await compute(
            ATHelperFuncs.generateCalendarData,
            [currentYear, month],
          );

          final treatedMonthData = await compute(
            ATHelperFuncs.transformDateTimes2Programs,
            [monthData, "Don't forget who you are", false]
          );
          newCalenderData.addAll(treatedMonthData);
        }

        noOfChunksFetched ++;
        
        emit(
          CalenderMonthViewDataState(
            calenderData: Map.from(newCalenderData),
            hasMoreData: hasMoreData,
            isLoadingMore: false
          )
        );

        newCalenderData.clear();
      } catch (_) {
        emit(
          CalenderMonthViewDataState(
            calenderData: dataState.calenderData,
            hasMoreData: hasMoreData,
            errorMsg: 'Coud not load items',
            isLoadingMore: false
          )
        );
      }
    });
  }
}



abstract class CalenderMonthViewState{}

class InitialCalenderMonthViewState extends CalenderMonthViewState{}

class CalenderMonthViewDataState extends CalenderMonthViewState{
  final Map<String, List<List<Map<DateTime?, List<CalenderProgram>>>>> calenderData;
  final bool hasMoreData, isLoadingMore;
  final String? errorMsg;
  CalenderMonthViewDataState({
    required this.calenderData,
    required this.hasMoreData,
    required this.isLoadingMore,
    this.errorMsg
  });
}

class CalenderMonthViewErrorState extends CalenderMonthViewState{}


class CalenderMonthViewLoadingState extends CalenderMonthViewState{}


abstract class  CalenderMonthViewEvent {}

class LoadInitialCalenderDataEvent extends CalenderMonthViewEvent{}
class LoadMoreCalenderDataEvent extends CalenderMonthViewEvent{}