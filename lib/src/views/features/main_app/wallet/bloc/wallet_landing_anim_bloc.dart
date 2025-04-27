import 'package:flutter_bloc/flutter_bloc.dart';

class WalletLandingAnimBloc extends Cubit<List<bool>>{
  WalletLandingAnimBloc(): super(List.generate(4,(_) => false));
  
  void triggerNext(int newIndex)async{
    if ((newIndex + 1) < 3) {
      state[newIndex] = true;
      emit(List.from(state));
    }
    else{
      await Future.delayed(const Duration(seconds: 2));
      state[newIndex] = true;
      emit(List.from(state));

      await Future.delayed(const Duration(milliseconds: 500));
      state[newIndex + 1] = true;
      emit(List.from(state));
    }
  }

  void reset() => emit(List.generate(4,(_) => false));
}