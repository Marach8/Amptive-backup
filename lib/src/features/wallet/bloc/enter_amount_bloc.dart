import 'package:flutter_bloc/flutter_bloc.dart';

class EnterAmountBloc extends Cubit<(String, bool)> {
  EnterAmountBloc() : super(('', true));

  void grabInput(String input) {
    final bool isValid = _inputIsValid(state.$1 + input);
    if (input.isEmpty || !isValid) return;

    emit(((state.$1 + input), _hasSufficientFunds(state.$1 + input)));
  }

  void removeLast() {
    if (state.$1.isEmpty) return;
    final String string = state.$1.substring(0, state.$1.length - 1);
    emit((string, _hasSufficientFunds(string)));

  }

  void clearInput() => emit(('', state.$2));

  bool _hasSufficientFunds(String input){
    final double inputNum = double.tryParse(input) ?? 0.0;
    if(inputNum > 1000000.0){
      return false;
    }
    else{
      return true;
    }
  }

  bool _inputIsValid(String input) {
    final double? value = double.tryParse(input);
    if (value == null) return false;

    final List<String> parts = input.split('.');
    if (parts.length == 2 && parts[1].length > 2) return false;

    return true;
  }
}