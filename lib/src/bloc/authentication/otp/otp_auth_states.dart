abstract class AmptiveOTPAuthState {}

class InitialAuthState extends AmptiveOTPAuthState {}

class LoadingAuthState extends AmptiveOTPAuthState {}

class ValidOTPAuthState extends AmptiveOTPAuthState {}
class InvalidOTPAuthState extends AmptiveOTPAuthState {}

class VerifiedOTPAuthState extends AmptiveOTPAuthState {}
class UnverifiedOTPAuthState extends AmptiveOTPAuthState {}

