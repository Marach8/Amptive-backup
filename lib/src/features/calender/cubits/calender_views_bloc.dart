import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final DateTime now = DateTime.now();

typedef CalenderViewsState = (int index, String viewName);

class CalenderViewsBloc extends Cubit<CalenderViewsState> {
  CalenderViewsBloc() : super((0, '${DateFormat('MMMM').format(now)} ${now.year}'));

  void selectView(int index) => emit((index, state.$2));

  void changeHeading(String newData) => emit((state.$1, newData));

  void showOnlyYear() => emit((state.$1, '${now.year}'));

  void showMonthAndYear() 
    => emit((state.$1, '${DateFormat('MMMM').format(now)} ${now.year}'));
}