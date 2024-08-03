import 'dart:async';

import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:amptive/src/utils/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'otp_auth_events.dart';
import 'otp_auth_states.dart';


class AmptiveOTPAuthBloc extends Bloc<AmptiveOTPAuthEvent, AmptiveOTPAuthState> {
  StreamSubscription<int>? _tickerSubscription;

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

    on<AmptiveOtpCountDownStartEvent>((event, emit)  {
      emit(AmptiveOTPCounterState(timeLeft: Constants.kTimerLimit));
      _tickerSubscription?.cancel();
      _tickerSubscription = _tick(Constants.kTimerLimit).listen((duration){
        add(AmptiveOtpCountDownEvent(secondsLeft: duration));
      });

    });


    on<AmptiveOtpCountDownEvent>((event, emit) {

      emit(event.secondsLeft >= 0
          ? AmptiveOTPCounterState(timeLeft: event.secondsLeft)
          : AmptiveOTPCounterCompleteState());

    });



  }

  Stream<int> _tick(int ticks) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1).take(ticks);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
