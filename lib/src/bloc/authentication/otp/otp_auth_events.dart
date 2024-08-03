abstract class AmptiveOTPAuthEvent {}

// otp auth events
class OTPChangedAuthEvent extends AmptiveOTPAuthEvent {
  final bool otpValid;

  OTPChangedAuthEvent({required this.otpValid});
}

class VerifyOTPAuthEvent extends AmptiveOTPAuthEvent {}

class AmptiveOtpCountDownEvent extends AmptiveOTPAuthEvent {
  final int secondsLeft;

  AmptiveOtpCountDownEvent({required this.secondsLeft});
}

class AmptiveOtpCountDownStartEvent extends AmptiveOTPAuthEvent {}
