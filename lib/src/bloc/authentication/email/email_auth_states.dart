abstract class ATAuthState {}

class InitialAuthState extends ATAuthState {}

class MainAuthState extends ATAuthState {
  MainAuthState({this.userEmail});
  String? userEmail;
}

class LoadingAuthState extends ATAuthState {}

class ValidEmailAuthState extends ATAuthState {}

class InvalidEmailAuthState extends ATAuthState {}
