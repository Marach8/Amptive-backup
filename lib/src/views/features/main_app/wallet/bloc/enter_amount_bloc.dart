import 'package:flutter_bloc/flutter_bloc.dart';

class EnterAmountBloc extends Cubit<(String, bool)> {
  EnterAmountBloc() : super(('', true));

  void grabInput(String input) {
    if (input.isEmpty) return;
    emit(((state.$1 + input), _validateAmount(state.$1 + input)));
  }

  void removeLast() {
    if (state.$1.isEmpty) return;
    final string = state.$1.substring(0, state.$1.length - 1);
    emit((string, _validateAmount(string)));

  }

  void clearInput() => emit(('', state.$2));

  bool _validateAmount(String input){
    final inputNum = double.tryParse(input) ?? 0;
    if(inputNum > 1000000){
      return false;
    }
    else{
      return true;
    }
  }
}