import 'dart:typed_data';

import 'package:country_pickers/country.dart';

abstract class AmptiveAuthState {}

abstract class SelectCountryCodeState extends AmptiveAuthState {
  final Country selectedCountry;

  SelectCountryCodeState({required this.selectedCountry});
}

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

class AddPhoneNumberState extends AmptiveAuthState {
  final bool isPhoneValid;

  AddPhoneNumberState({required this.isPhoneValid});
}

class OpenCountryBottomSheetState extends SelectCountryCodeState {
  OpenCountryBottomSheetState({required super.selectedCountry});
}

class PickCountryCodeState extends SelectCountryCodeState {
  PickCountryCodeState({required super.selectedCountry});
}
