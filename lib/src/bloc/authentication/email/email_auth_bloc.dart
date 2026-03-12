import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'email_auth_events.dart';
import 'email_auth_states.dart';
import '../../../services/auth/auth_field_service.dart';

class ATEmailAuthBloc extends Bloc<ATEmailAuthEvent, ATAuthState> {
  ATEmailAuthBloc() : super(InitialAuthState()) {
    on<EmailFieldChangedAuthEvent>(
        (EmailFieldChangedAuthEvent event, Emitter<ATAuthState> emit) {
      final String? currentTextEntered = event.currentTextEntered;

      emit(MainAuthState(userEmail: currentTextEntered));
    });

    on<VerifyEmailAuthEvent>(
        (VerifyEmailAuthEvent event, Emitter<ATAuthState> emit) async {
      emit(LoadingAuthState());

      final bool processed = await GetIt.I<AuthFieldService>().processEmail();

      if (processed) {
        emit(ValidEmailAuthState());
      } else {
        emit(InvalidEmailAuthState());
      }
    });
  }
}
