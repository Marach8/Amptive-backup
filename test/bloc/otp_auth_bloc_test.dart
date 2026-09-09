import 'package:amptive/src/bloc/authentication/otp/otp_auth_bloc.dart';
import 'package:amptive/src/bloc/authentication/otp/otp_auth_events.dart';
import 'package:amptive/src/bloc/authentication/otp/otp_auth_states.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AmptiveOTPAuthBloc', () {
    blocTest<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
      'emits AmptiveOTPCounterState(timeLeft: kTimerLimit) on '
      'AmptiveOtpCountDownStartEvent',
      build: () => AmptiveOTPAuthBloc(),
      act: (AmptiveOTPAuthBloc bloc) => bloc.add(const AmptiveOtpCountDownStartEvent()),
      expect: <AmptiveOTPAuthState>[
        const AmptiveOTPCounterState(timeLeft: 10),
      ],
    );

    blocTest<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
      'emits AmptiveOTPCounterState for non-negative secondsLeft on '
      'AmptiveOtpCountDownEvent',
      build: () => AmptiveOTPAuthBloc(),
      act: (AmptiveOTPAuthBloc bloc) => bloc.add(const AmptiveOtpCountDownEvent(secondsLeft: 5)),
      expect: <AmptiveOTPAuthState>[
        const AmptiveOTPCounterState(timeLeft: 5),
      ],
    );

    blocTest<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
      'emits AmptiveOTPCounterCompleteState for negative secondsLeft on '
      'AmptiveOtpCountDownEvent',
      build: () => AmptiveOTPAuthBloc(),
      act: (AmptiveOTPAuthBloc bloc) => bloc.add(const AmptiveOtpCountDownEvent(secondsLeft: -1)),
      expect: <AmptiveOTPAuthState>[const AmptiveOTPCounterCompleteState()],
    );

    blocTest<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
      'emits InvalidOTPAuthState when OTP is not valid',
      build: () => AmptiveOTPAuthBloc(),
      act: (AmptiveOTPAuthBloc bloc) => bloc.add(const OTPChangedAuthEvent(otpValid: false)),
      expect: <AmptiveOTPAuthState>[const InvalidOTPAuthState()],
    );

    blocTest<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
      'emits ValidOTPAuthState when OTP is valid',
      build: () => AmptiveOTPAuthBloc(),
      act: (AmptiveOTPAuthBloc bloc) => bloc.add(const OTPChangedAuthEvent(otpValid: true)),
      expect: <AmptiveOTPAuthState>[const ValidOTPAuthState()],
    );

    blocTest<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
      'emits VerifiedOTPAuthState on ValidOTPAuthEvent',
      build: () => AmptiveOTPAuthBloc(),
      act: (AmptiveOTPAuthBloc bloc) => bloc.add(const ValidOTPAuthEvent()),
      expect: <AmptiveOTPAuthState>[const VerifiedOTPAuthState()],
    );
  });
}