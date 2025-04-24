import 'package:flutter_bloc/flutter_bloc.dart';

class WalletLandingAnimBloc extends Cubit<List<bool>>{
  WalletLandingAnimBloc(): super(List.generate(3,(_) => false));
  
  void triggerNext(int newIndex)async{
    if ((newIndex + 1) < state.length) {
      state[newIndex] = true;
      emit(List.from(state));
    }
    else{
      await Future.delayed(const Duration(seconds: 2));
      state[newIndex] = true;
      emit(List.from(state));
    }
  }

  void reset() => emit(List.generate(3,(_) => false));
}