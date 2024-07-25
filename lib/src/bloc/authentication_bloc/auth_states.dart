abstract class AmptiveAuthState{
  String? userEmail;
  AmptiveAuthState({this.userEmail});
}


class InitialAuthState extends AmptiveAuthState{}

class MainAuthState extends AmptiveAuthState{
  MainAuthState({super.userEmail});
}

class LoadingAuthState extends AmptiveAuthState {}

class LoadedAuthState extends AmptiveAuthState {}