import 'package:flutter_bloc/flutter_bloc.dart';

class CalenderViewsBloc extends Cubit<int>{
  CalenderViewsBloc(): super(0);

  void selectView(int index) => emit(index);
}