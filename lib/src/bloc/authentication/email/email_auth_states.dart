abstract class AmptiveEmailAuthState {}

class InitialAuthState extends AmptiveEmailAuthState {}

class MainAuthState extends AmptiveEmailAuthState {
  String? userEmail;

  MainAuthState({this.userEmail});
}

class LoadingAuthState extends AmptiveEmailAuthState {}

class ValidEmailAuthState extends AmptiveEmailAuthState {}

class InvalidEmailAuthState extends AmptiveEmailAuthState {}