import 'dart:typed_data';

import 'package:country_pickers/country.dart';

abstract class AmptiveAuthState {}

abstract class SelectCountryCodeState extends AmptiveAuthState {

  SelectCountryCodeState({required this.selectedCountry});
  final Country selectedCountry;
}

class InitialAuthState extends AmptiveAuthState {}

class EditDOBAuthState extends AmptiveAuthState {

  EditDOBAuthState({this.dob});
  DateTime? dob;
}

class HideOrShowPasswordAuthState extends AmptiveAuthState {}

class VerifyingUsernameState extends AmptiveAuthState {}

class UsernameVerifiedState extends AmptiveAuthState {}

class NameChangedState extends AmptiveAuthState {}

class AddProfilePictureState extends AmptiveAuthState {}

class ProfilePictureAddedState extends AmptiveAuthState {

  ProfilePictureAddedState({required this.image});
  final Uint8List? image;
}

class AddPhoneNumberState extends AmptiveAuthState {

  AddPhoneNumberState({required this.isPhoneValid});
  final bool isPhoneValid;
}

class OpenCountryBottomSheetState extends SelectCountryCodeState {
  OpenCountryBottomSheetState({required super.selectedCountry});
}

class PickCountryCodeState extends SelectCountryCodeState {
  PickCountryCodeState({required super.selectedCountry});
}
