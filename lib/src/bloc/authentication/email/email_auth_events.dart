abstract class ATEmailAuthEvent {}

class VerifyEmailAuthEvent extends ATEmailAuthEvent {}

class EmailFieldChangedAuthEvent extends ATEmailAuthEvent {
  String? currentTextEntered;

  EmailFieldChangedAuthEvent({this.currentTextEntered});
}