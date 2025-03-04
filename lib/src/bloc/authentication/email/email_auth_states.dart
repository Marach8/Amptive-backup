abstract class ATAuthState {}

class InitialAuthState extends ATAuthState {}

class MainAuthState extends ATAuthState {
  String? userEmail;

  MainAuthState({this.userEmail});
}

class LoadingAuthState extends ATAuthState {}

class ValidEmailAuthState extends ATAuthState {}

class InvalidEmailAuthState extends ATAuthState {}