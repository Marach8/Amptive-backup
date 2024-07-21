abstract class AmptiveAuthState{
  String? userEmail,
  otpInputFromUser;
  int? resendOTPCountDown;

  AmptiveAuthState({
    this.userEmail,
    this.resendOTPCountDown,
    this.otpInputFromUser
  });

  @override
  bool operator ==(covariant AmptiveAuthState other)
    => userEmail == other.userEmail &&
    resendOTPCountDown == other.resendOTPCountDown && 
    otpInputFromUser == other.otpInputFromUser;

  @override
  int get hashCode => userEmail.hashCode ^
    resendOTPCountDown.hashCode ^
    otpInputFromUser.hashCode;
}


class InitialAuthState extends AmptiveAuthState{}

class MainAuthState extends AmptiveAuthState{
  MainAuthState({
    super.userEmail,
    super.resendOTPCountDown,
    super.otpInputFromUser
  });

  MainAuthState copyWith({
    String? userEmail,
    int? resendOTPCountDown,
    String? otpInputFromUser
  }) => MainAuthState(
    userEmail: userEmail ?? this.userEmail,
    resendOTPCountDown: resendOTPCountDown ?? this.resendOTPCountDown,
    otpInputFromUser: otpInputFromUser ?? this.otpInputFromUser
  );
}