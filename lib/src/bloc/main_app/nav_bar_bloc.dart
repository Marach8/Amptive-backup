import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveNavBarBloc extends Cubit<int>{
  AmptiveNavBarBloc(): super(0);

  void goToPage(int index) => emit(index);
}