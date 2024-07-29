abstract class AmptiveAuthEvent{}


class VerifyEmailAuthEvent extends AmptiveAuthEvent{
  final String userEmail;
  VerifyEmailAuthEvent({required this.userEmail});
}

class GetTheCurrentTextOnTheEmailFieldAuthEvent extends AmptiveAuthEvent{
  String? currentTextOnTheEmailField;
  GetTheCurrentTextOnTheEmailFieldAuthEvent({this.currentTextOnTheEmailField});
}

class ResendOTPCountDownTimerAuthEvent extends AmptiveAuthEvent{
  final int? countDownTime;
  ResendOTPCountDownTimerAuthEvent({this.countDownTime});
}

class OTPFieldIsCompletedAuthEvent extends AmptiveAuthEvent{
  final String? otpInputFromUser;
  OTPFieldIsCompletedAuthEvent({this.otpInputFromUser});
}

class HideOrShowPasswordAuthEvent extends AmptiveAuthEvent{}

class GetTheCurrentTextOnThePaaswordFieldAuthEvent extends AmptiveAuthEvent{
  String? currentTextOnThePasswordField;
  GetTheCurrentTextOnThePaaswordFieldAuthEvent({this.currentTextOnThePasswordField});
}