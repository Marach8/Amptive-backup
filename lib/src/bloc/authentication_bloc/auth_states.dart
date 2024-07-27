abstract class AmptiveAuthState {}

class InitialAuthState extends AmptiveAuthState {}

class MainAuthState extends AmptiveAuthState {
  String? userEmail;

  MainAuthState({this.userEmail});
}

class LoadingAuthState extends AmptiveAuthState {}

class ValidAuthState extends AmptiveAuthState {}

class InValidAuthState extends AmptiveAuthState {}

// otp states
class ValidOTPAuthState extends AmptiveAuthState {}

class InValidOTPAuthState extends AmptiveAuthState {}

// password states
class ValidPasswordAuthState extends AmptiveAuthState {}

class InValidPasswordAuthState extends AmptiveAuthState {}
