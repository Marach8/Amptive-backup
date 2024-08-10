import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';

abstract class AmptiveAuthEvent {
  const AmptiveAuthEvent();
}

class EditDOBAuthEvent extends AmptiveAuthEvent {
  DateTime? selectedDate;

  EditDOBAuthEvent({this.selectedDate});
}

class HideOrShowPasswordAuthEvent extends AmptiveAuthEvent {}

class UsernameChangedEvent extends AmptiveAuthEvent {
  final String username;

  const UsernameChangedEvent(this.username);
}

class UsernameValidationComplete extends AmptiveAuthEvent {}

class NameChangedEvent extends AmptiveAuthEvent {}

class ProfilePictureAddedEvent extends AmptiveAuthEvent {
  final MemoryImage image;

  ProfilePictureAddedEvent({required this.image});
}

class AddProfilePictureEvent extends AmptiveAuthEvent {
  final bool cancel;

  AddProfilePictureEvent({required this.cancel});
}

class AddPhoneNumberEvent extends AmptiveAuthEvent {
  final String? value;

  AddPhoneNumberEvent({required this.value});
}

class PickCountryCodeEvent extends AmptiveAuthEvent {
  final Country country;

  PickCountryCodeEvent({required this.country});
}

class OpenCountryBottomSheetEvent extends AmptiveAuthEvent {}
