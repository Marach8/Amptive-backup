abstract class AmptiveAuthState{
  String? userEmail,
  userPassword,
  otpInputFromUser;
  int? resendOTPCountDown;
  bool? hidePassword;

  AmptiveAuthState({
    this.userEmail,
    this.resendOTPCountDown,
    this.otpInputFromUser,
    this.hidePassword,
    this.userPassword
  });

  @override
  bool operator ==(covariant AmptiveAuthState other)
    => userEmail == other.userEmail &&
    resendOTPCountDown == other.resendOTPCountDown && 
    otpInputFromUser == other.otpInputFromUser &&
    hidePassword == other.hidePassword &&
    userPassword == other.userPassword;

  @override
  int get hashCode => userEmail.hashCode ^
    resendOTPCountDown.hashCode ^
    otpInputFromUser.hashCode ^
    hidePassword.hashCode ^ 
    userPassword.hashCode;
}


class InitialAuthState extends AmptiveAuthState{}

class MainAuthState extends AmptiveAuthState{
  MainAuthState({super.userEmail});
}

class LoadingAuthState extends AmptiveAuthState{}

class LoadedAuthState extends AmptiveAuthState{}