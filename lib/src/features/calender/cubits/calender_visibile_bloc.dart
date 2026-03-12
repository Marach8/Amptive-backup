import 'package:flutter_bloc/flutter_bloc.dart';

class CalenderVisibleBloc extends Cubit<bool> {
  CalenderVisibleBloc() : super(false);

  void toggleSeeCalender() => emit(!state);
}
