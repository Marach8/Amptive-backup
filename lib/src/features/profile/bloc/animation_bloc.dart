import 'package:flutter_bloc/flutter_bloc.dart';

class AcctTypeLandingAnimBloc extends Cubit<List<bool>> {
  AcctTypeLandingAnimBloc() : super(List.generate(4, (_) => false));

  void triggerNext(int newIndex) async {
    if (newIndex < state.length) {
      state[newIndex] = true;
      emit(List.from(state));
    }
  }

  void reset() => emit(List.generate(4, (_) => false));
}

class SwitchAcctSuccessAnimBloc extends Cubit<List<bool>> {
  SwitchAcctSuccessAnimBloc() : super(List.filled(5, false));

  void triggerNext(int newIndex) async {
    if (newIndex < 3) {
      state[newIndex] = true;
      emit(List.from(state));
      await Future.delayed(const Duration(seconds: 3));
      state[newIndex] = false;
      emit(List.from(state));
    } else {
      _showSuccesState();
    }
  }

  void _showSuccesState() async {
    state[3] = true;
    emit(List.from(state));
    await Future.delayed(const Duration(milliseconds: 50));
    state[4] = true;
    emit(List.from(state));
  }

  void reset() => emit(List.filled(5, false));
}
