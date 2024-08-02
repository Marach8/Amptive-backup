import 'dart:typed_data';

abstract class AmptiveAuthState {}

class InitialAuthState extends AmptiveAuthState {}

class EditDOBAuthState extends AmptiveAuthState {
  DateTime? dob;

  EditDOBAuthState({this.dob});
}

class HideOrShowPasswordAuthState extends AmptiveAuthState {}

class UsernameLoadingAuthState extends AmptiveAuthState {}

class UsernameValidatedAuthState extends AmptiveAuthState {}

class NameChangedState extends AmptiveAuthState {}

class AddProfilePictureState extends AmptiveAuthState {}

class ProfilePictureAddedState extends AmptiveAuthState {
  final Uint8List? image;

  ProfilePictureAddedState({required this.image});
}
