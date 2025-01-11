import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'email_auth_events.dart';
import 'email_auth_states.dart';
import '../../../services/auth/auth_field_service.dart';

class AmptiveEmailAuthBloc extends Bloc<AmptiveEmailAuthEvent, AmptiveEmailAuthState> {
  AmptiveEmailAuthBloc() : super(InitialAuthState()) {
    on<EmailFieldChangedAuthEvent>((event, emit) {
      final currentTextEntered = event.currentTextEntered;

      emit(MainAuthState(userEmail: currentTextEntered));
    });

    on<VerifyEmailAuthEvent>((event, emit) async {
      emit(LoadingAuthState());

      final processed = await GetIt.I<AuthFieldService>().processEmail();

      if (processed) {
        emit(ValidEmailAuthState());
      } else {
        emit(InvalidEmailAuthState());
      }
    });
  }
}
