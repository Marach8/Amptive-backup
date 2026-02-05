import 'dart:async';

import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:amptive/src/config/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'otp_auth_events.dart';
import 'otp_auth_states.dart';


class AmptiveOTPAuthBloc extends Bloc<AmptiveOTPAuthEvent, AmptiveOTPAuthState> {

  AmptiveOTPAuthBloc() : super(InitialAuthState()) {

    on<OTPChangedAuthEvent>((OTPChangedAuthEvent event, Emitter<AmptiveOTPAuthState> emit) {
      if (event.otpValid) {
        emit(ValidOTPAuthState());
      } else {
        emit(InvalidOTPAuthState());
      }
    });

    on<VerifyOTPAuthEvent>((VerifyOTPAuthEvent event, Emitter<AmptiveOTPAuthState> emit) async {
      emit(LoadingAuthState());

      final bool processed = await GetIt.I<OtpService>().validateOtp();

      if (processed) {
        emit(VerifiedOTPAuthState());
      } else {
        emit(UnverifiedOTPAuthState());
      }
    });

    on<AmptiveOtpCountDownStartEvent>((AmptiveOtpCountDownStartEvent event, Emitter<AmptiveOTPAuthState> emit)  {
      emit(AmptiveOTPCounterState(timeLeft: Constants.kTimerLimit));
      _tickerSubscription?.cancel();
      _tickerSubscription = _tick(Constants.kTimerLimit).listen((int duration){
        add(AmptiveOtpCountDownEvent(secondsLeft: duration));
      });

    });


    on<AmptiveOtpCountDownEvent>((AmptiveOtpCountDownEvent event, Emitter<AmptiveOTPAuthState> emit) {

      emit(event.secondsLeft >= 0
          ? AmptiveOTPCounterState(timeLeft: event.secondsLeft)
          : AmptiveOTPCounterCompleteState());

    });

    on<ValidOTPAuthEvent>((_, Emitter<AmptiveOTPAuthState> emit){
      emit(VerifiedOTPAuthState());
    });
  }
  StreamSubscription<int>? _tickerSubscription;

  Stream<int> _tick(int ticks) {
    return Stream.periodic(const Duration(seconds: 1), (int x) => ticks - x - 1).take(ticks);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
