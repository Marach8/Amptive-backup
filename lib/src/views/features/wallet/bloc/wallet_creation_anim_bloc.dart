import 'package:flutter_bloc/flutter_bloc.dart';

class WalletCreationAnimBloc extends Cubit<List<bool>>{
  WalletCreationAnimBloc(): super(List.filled(4, false));
  
  void triggerNext(int newIndex)async{
    if (newIndex < 3) {
      state[newIndex] = true;
      emit(List.from(state));
      await Future.delayed(const Duration(seconds: 3));
      state[newIndex] = false;
      emit(List.from(state));
    }
    else{
      showSuccesState();
    }
  }

  void showSuccesState() async{
    state[3] = true;
    emit(List.from(state));
  }
} 