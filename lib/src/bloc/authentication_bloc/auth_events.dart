abstract class AmptiveAuthEvent {}

class VerifyEmailAuthEvent extends AmptiveAuthEvent {}

class EmailFieldChangedAuthEvent extends AmptiveAuthEvent {
  String? currentTextEntered;

  EmailFieldChangedAuthEvent({this.currentTextEntered});
}

// otp auth events
class OTPChangedAuthEvent extends AmptiveAuthEvent {
  final bool otpValid;

  OTPChangedAuthEvent({required this.otpValid});
}

class VerifyOTPAuthEvent extends AmptiveAuthEvent {}

// password auth event
class PasswordChangedAuthEvent extends AmptiveAuthEvent {}
