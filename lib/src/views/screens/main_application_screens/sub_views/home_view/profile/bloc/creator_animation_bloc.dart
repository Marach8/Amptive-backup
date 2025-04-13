import 'package:flutter_bloc/flutter_bloc.dart';

class CreatorLandingAnimationBloc extends Cubit<List<bool>>{
  CreatorLandingAnimationBloc(): super(List.generate(4,(_) => false));
  
  void triggerNext(int newIndex)async{
    if (newIndex < state.length) {
      state[newIndex] = true;
      emit(List.from(state));
    }
  }

  void reset() => emit(List.generate(4,(_) => false));
}




class SwitchAcctSuccessAnimationBloc extends Cubit<List<bool>>{
  SwitchAcctSuccessAnimationBloc(): super(List.generate(5,(_) => false));
  
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
    await Future.delayed(const Duration(milliseconds: 50));
    state[4] = true;
    emit(List.from(state));
  }

  void reset() => emit(List.generate(5,(_) => false));
} 