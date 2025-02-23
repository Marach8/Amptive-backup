
import 'package:flutter_bloc/flutter_bloc.dart';

class AllowSeeCalenderBloc extends Cubit<bool>{
  AllowSeeCalenderBloc(): super(false);

  void toggleSeeCalender() => emit(!state);
}