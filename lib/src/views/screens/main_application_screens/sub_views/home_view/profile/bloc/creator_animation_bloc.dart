import 'package:flutter_bloc/flutter_bloc.dart';

class CreatorAnimationBloc extends Cubit<List<bool>>{
  CreatorAnimationBloc(): super(List.generate(4,(_) => false));
  
  void triggerNext(int newIndex)async{
    if (newIndex < state.length) {
      state[newIndex] = true;
      emit(List.from(state));
    }
  }

  void reset() => emit(List.generate(4,(_) => false));
}