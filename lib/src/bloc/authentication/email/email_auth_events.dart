abstract class ATEmailAuthEvent {}

class VerifyEmailAuthEvent extends ATEmailAuthEvent {}

class EmailFieldChangedAuthEvent extends ATEmailAuthEvent {
  EmailFieldChangedAuthEvent({this.currentTextEntered});
  String? currentTextEntered;
}
