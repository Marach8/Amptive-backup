import 'package:flutter_bloc/flutter_bloc.dart';

class EnterPinBloc extends Cubit<(String, bool?)> {
  EnterPinBloc() : super(('', true));

  void grabPin(String input) async {
    if (input.isEmpty || state.$1.length == 4) return;

    if ((state.$1 + input).length == 4) {
      emit(((state.$1 + input), null));
      final bool isValid = await _validatePin(state.$1);
      if (isValid) {
        emit(((state.$1), isValid));
        return;
      } else {
        emit(('', false));
        return;
      }
    }
    emit(((state.$1 + input), true));
  }

  void deletePin() {
    if (state.$1.isEmpty) return;
    final String newPin = state.$1.substring(0, state.$1.length - 1);
    emit((newPin, state.$2));
  }

  Future<bool> _validatePin(String pin) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (pin == '1234') {
      return true;
    } else {
      return false;
    }
  }
}
