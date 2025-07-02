import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DayViewHeadingBloc extends Bloc<DateAndWeekDaysEvent, DayViewHeadingState> {
  DayViewHeadingBloc() : super(DayViewHeadingInitial()) {
    on<InitializeDayViewHeadingEvent>((InitializeDayViewHeadingEvent event, Emitter<DayViewHeadingState> emit)async{
      try {
        final DateTime now = DateTime.now();
        emit (DayViewHeadingLoading());
        final List<List<DateTime?>> weeks = await compute(
          ATHelperFuncs.getWeeksInAMonth,
          <int>[now.year, now.month]
        );

        int initialPage = 0;
        for (int i = 0; i < weeks.length; i++) {
          if (weeks[i].any((DateTime? day) => day?.day == now.day)) {
            initialPage = i;
            break;
          }
        }

        emit(DayViewHeadingData(weeks, initialPage));
      } catch (e) {
        emit(DateAndWeekDaysError(e.toString()));
      }
    });
  }
}






abstract class DayViewHeadingState {}

class DayViewHeadingLoading extends DayViewHeadingState{}

class DayViewHeadingInitial extends DayViewHeadingState {}

class DayViewHeadingData extends DayViewHeadingState {

  DayViewHeadingData(this.weeks, this.initialPage);
  final List<List<DateTime?>> weeks;
  final int initialPage;
}

class DateAndWeekDaysError extends DayViewHeadingState {

  DateAndWeekDaysError(this.error);
  final String error;
}



abstract class DateAndWeekDaysEvent {}

class InitializeDayViewHeadingEvent extends DateAndWeekDaysEvent {}





typedef HoursInADayState = (bool status, List<String> hours);

class HoursInADayBloc extends Cubit<HoursInADayState?>{
  HoursInADayBloc(): super(null);

  void generateHoursInADay() async{
    emit((false, <String>[]));
    
    final List<String> hours = await compute(
      ATHelperFuncs.generateHoursInADay,
      null
    );

    emit((true, hours));
  }
}
