import 'package:amptive/src/bloc/authentication_bloc/auth_events.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_states.dart';
import 'package:amptive/src/services/authentication_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveAuthBloc extends Bloc<AmptiveAuthEvent, AmptiveAuthState> {
  AmptiveAuthBloc() : super(InitialAuthState()) {
    on<GetTheCurrentTextEnteredByTheUserAuthEvent>((event, emit) {
      final currentTextEntered = event.currentTextEnteredByUser;

      emit(MainAuthState(userEmail: currentTextEntered));
    });

    on<VerifyEmailAuthEvent>((event, emit) async {
      emit(LoadingAuthState());

      final processed = await AuthenticationService().processEmail(event.userEmail);

      if (processed) {
        emit(LoadedAuthState());
      } else {
        emit(LoadedAuthState());
      }
    });
  }
}
