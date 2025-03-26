import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedCalenderDateBloc extends Cubit<DateTime?>{
  SelectedCalenderDateBloc(): super(null);

  void pickADate(DateTime? date) => emit(date);
}