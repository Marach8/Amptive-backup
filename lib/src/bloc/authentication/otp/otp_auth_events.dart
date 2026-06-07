abstract class AmptiveOTPAuthEvent {}

// otp auth events
class OTPChangedAuthEvent extends AmptiveOTPAuthEvent {
  OTPChangedAuthEvent({required this.otpValid});
  final bool otpValid;
}

class VerifyOTPAuthEvent extends AmptiveOTPAuthEvent {}

class AmptiveOtpCountDownEvent extends AmptiveOTPAuthEvent {
  AmptiveOtpCountDownEvent({required this.secondsLeft});
  final int secondsLeft;
}

class AmptiveOtpCountDownStartEvent extends AmptiveOTPAuthEvent {}

class ValidOTPAuthEvent extends AmptiveOTPAuthEvent {}
