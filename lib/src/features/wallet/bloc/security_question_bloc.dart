import 'package:flutter_bloc/flutter_bloc.dart';

class SecQuestionBloc extends Cubit<(String?, bool, String)> {
  SecQuestionBloc() : super((null, false, ''));

  void setSecQuestion(String question) => Future.delayed(
      const Duration(milliseconds: 500),
      () => emit((question, state.$2, state.$3)));

  void toggleIcon() => emit((state.$1, !state.$2, state.$3));

  void setSecAnswer(String answer) => emit((state.$1, !state.$2, answer));
}
