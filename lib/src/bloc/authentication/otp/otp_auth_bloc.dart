import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'otp_auth_events.dart';
import 'otp_auth_states.dart';


class AmptiveOTPAuthBloc extends Bloc<AmptiveOTPAuthEvent, AmptiveOTPAuthState> {
  AmptiveOTPAuthBloc() : super(InitialAuthState()) {

    on<OTPChangedAuthEvent>((event, emit) {
      if (event.otpValid) {
        emit(ValidOTPAuthState());
      } else {
        emit(InvalidOTPAuthState());
      }
    });

    on<VerifyOTPAuthEvent>((event, emit) async {
      emit(LoadingAuthState());

      final processed = await GetIt.I<OtpService>().validateOtp();

      if (processed) {
        emit(VerifiedOTPAuthState());
      } else {
        emit(UnverifiedOTPAuthState());
      }
    });

    on<AmptiveOtpCountDownEvent>((event, emit) async {
      emit(AmptiveOTPCounterState(timeLeft: event.secondsLeft));

    });

  }
}
