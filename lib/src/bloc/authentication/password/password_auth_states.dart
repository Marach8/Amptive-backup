abstract class AmptivePasswordAuthState {
  String? error;

  AmptivePasswordAuthState({this.error});
}

class InitialAuthState extends AmptivePasswordAuthState {}

// password states
class ValidPasswordAuthState extends AmptivePasswordAuthState {
  ValidPasswordAuthState({super.error});
}

class InValidPasswordAuthState extends AmptivePasswordAuthState {
  InValidPasswordAuthState({super.error});
}
