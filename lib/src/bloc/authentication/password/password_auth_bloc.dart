import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../services/auth/auth_field_service.dart';
import 'password_auth_events.dart';
import 'password_auth_states.dart';


class AmptivePasswordAuthBloc extends Bloc<AmptivePasswordAuthEvent, AmptivePasswordAuthState> {
  AmptivePasswordAuthBloc() : super(InitialAuthState()) {

    // password auth listeners
    on<PasswordChangedAuthEvent>((event, emit) {
      final service = GetIt.I<AuthFieldService>();

      service.validatePassword(event.value);


      if (service.isPasswordValid) {
        emit(ValidPasswordAuthState(error: service.password.error));
      } else {
        emit(InValidPasswordAuthState(error: service.password.error));
      }
    });
  }
}
