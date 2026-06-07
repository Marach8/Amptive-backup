abstract class AmptivePasswordAuthEvent {}

// password auth event
class PasswordChangedAuthEvent extends AmptivePasswordAuthEvent {
  PasswordChangedAuthEvent({required this.value});
  final String value;
}
