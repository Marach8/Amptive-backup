abstract class AmptiveAuthEvent{}


class VerifyEmailAuthEvent extends AmptiveAuthEvent{
  final String userEmail;
  VerifyEmailAuthEvent({required this.userEmail});
}

class GetTheCurrentTextEnteredByTheUserAuthEvent extends AmptiveAuthEvent{
  String? currentTextEnteredByUser;
  GetTheCurrentTextEnteredByTheUserAuthEvent({this.currentTextEnteredByUser});
}