abstract class AmptivePasswordAuthState {

  AmptivePasswordAuthState({this.error});
  String? error;
}

class InitialAuthState extends AmptivePasswordAuthState {}

// password states
class ValidPasswordAuthState extends AmptivePasswordAuthState {
  ValidPasswordAuthState({super.error});
}

class InValidPasswordAuthState extends AmptivePasswordAuthState {
  InValidPasswordAuthState({super.error});
}
