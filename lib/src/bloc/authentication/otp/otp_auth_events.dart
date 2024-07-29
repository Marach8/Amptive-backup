abstract class AmptiveOTPAuthEvent {}


// otp auth events
class OTPChangedAuthEvent extends AmptiveOTPAuthEvent {
  final bool otpValid;

  OTPChangedAuthEvent({required this.otpValid});
}

class VerifyOTPAuthEvent extends AmptiveOTPAuthEvent {}

