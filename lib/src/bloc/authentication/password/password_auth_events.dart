abstract class AmptivePasswordAuthEvent {}


// password auth event
class PasswordChangedAuthEvent extends AmptivePasswordAuthEvent {
  final String value;

  PasswordChangedAuthEvent({required this.value});
}
