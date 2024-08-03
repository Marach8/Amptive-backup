abstract class AmptiveEmailAuthEvent {}

class VerifyEmailAuthEvent extends AmptiveEmailAuthEvent {}

class EmailFieldChangedAuthEvent extends AmptiveEmailAuthEvent {
  String? currentTextEntered;

  EmailFieldChangedAuthEvent({this.currentTextEntered});
}