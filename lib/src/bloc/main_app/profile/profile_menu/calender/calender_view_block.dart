import 'package:flutter_bloc/flutter_bloc.dart';

class CalenderViewBloc extends Cubit<List>{
  CalenderViewBloc():super(['English', false]);

  void showLanguages(){
    final newState = List.from(state);
    newState.last = true;
    emit(newState);
  }
  

  void selectLanguage(String lang){
    final newState = List.from(state);
    newState.first = lang;
    //Hide languages after a selection
    newState.last = false;
    emit(newState);
  }
}