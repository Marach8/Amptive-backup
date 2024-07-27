import 'package:amptive/src/bloc/authentication_bloc/auth_events.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_states.dart';
import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../services/auth/auth_field_service.dart';

class AmptiveAuthBloc extends Bloc<AmptiveAuthEvent, AmptiveAuthState> {
  AmptiveAuthBloc() : super(InitialAuthState()) {
    on<EmailFieldChangedAuthEvent>((event, emit) {
      final currentTextEntered = event.currentTextEntered;

      emit(MainAuthState(userEmail: currentTextEntered));
    });

    on<VerifyEmailAuthEvent>((event, emit) async {
      emit(LoadingAuthState());

      final processed = await GetIt.I<AuthFieldService>().processEmail();

      if (processed) {
        emit(ValidAuthState());
      } else {
        emit(InValidAuthState());
      }
    });

    on<OTPChangedAuthEvent>((event, emit) {
      if (event.otpValid) {
        emit(ValidOTPAuthState());
      } else {
        emit(InValidOTPAuthState());
      }
    });

    on<VerifyOTPAuthEvent>((event, emit) async {
      emit(LoadingAuthState());

      final processed = await GetIt.I<OtpService>().validateOtp();

      if (processed) {
        emit(ValidAuthState());
      } else {
        emit(InValidAuthState());
      }
    });

    // password auth listeners
    on<PasswordChangedAuthEvent>((event, emit) {
      final valid = GetIt.I<AuthFieldService>().isPasswordValid;

      if (valid) {
        emit(ValidPasswordAuthState());
      } else {
        emit(InValidOTPAuthState());
      }
    });
  }
}
