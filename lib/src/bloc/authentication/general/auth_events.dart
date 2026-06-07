import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';

abstract class AmptiveAuthEvent {
  const AmptiveAuthEvent();
}

class EditDOBAuthEvent extends AmptiveAuthEvent {
  EditDOBAuthEvent({this.selectedDate});
  DateTime? selectedDate;
}

class HideOrShowPasswordAuthEvent extends AmptiveAuthEvent {}

class UsernameChangedEvent extends AmptiveAuthEvent {
  const UsernameChangedEvent(this.username);
  final String username;
}

class UsernameValidationComplete extends AmptiveAuthEvent {}

class NameChangedEvent extends AmptiveAuthEvent {}

class ProfilePictureAddedEvent extends AmptiveAuthEvent {
  ProfilePictureAddedEvent({required this.image});
  final MemoryImage image;
}

class AddProfilePictureEvent extends AmptiveAuthEvent {
  AddProfilePictureEvent({required this.cancel});
  final bool cancel;
}

class AddPhoneNumberEvent extends AmptiveAuthEvent {
  AddPhoneNumberEvent({required this.value});
  final String? value;
}

class PickCountryCodeEvent extends AmptiveAuthEvent {
  PickCountryCodeEvent({required this.country});
  final Country country;
}

class OpenCountryBottomSheetEvent extends AmptiveAuthEvent {}
