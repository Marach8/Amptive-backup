import 'package:amptive/utils/utils.dart';
import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  ValidationModel _email = ValidationModel(null, null);
  ValidationModel _customEmailStatus =
      ValidationModel("This email will be verified in the next step.", null);

  ValidationModel _password =
      ValidationModel(null, "Your password should be at least 8 characters.");
  ValidationModel _name = ValidationModel(null, null);
  ValidationModel _dob = ValidationModel(null, null);

  ValidationModel get email => _email;

  ValidationModel get dob => _dob;

  ValidationModel get customEmailStatus => _customEmailStatus;

  ValidationModel get password => _password;

  ValidationModel get name => _name;


  void validateEmail(String? val) {
    if (val != null && val.isValidEmail) {
      //todo: check network before this
      _email = ValidationModel(val, null);
      _customEmailStatus = ValidationModel(
          "This email will be verified in the next step.", null);
    } else if (val == null || val.isEmpty) {
      _email = ValidationModel(null, 'Required');
      _customEmailStatus = ValidationModel(null, null);
    } else {
      _email = ValidationModel(null, 'Email address in invalid');
      _customEmailStatus = ValidationModel(null, null);
    }
    notifyListeners();
  }

  void validatePassword(String? val) {
    if (val != null && val.length >= 8) {
      // todo add better password validation
      _password = ValidationModel(val, null);
    } else if (val == null || val.length < 8) {
      _password = ValidationModel(
          null, "Your password should be at least 8 characters.");
    } else {
      _password = ValidationModel(null,
          'Password must contain an uppercase, lowercase, numeric digit and special character');
    }
    notifyListeners();
  }

  void validateDOB(String? val) {
    if (val != null) {
      _name = ValidationModel(val, null);
    } else {
      _name = ValidationModel(null, null);
    }
    notifyListeners();
  }

  void validateName(String? val) {
    if (val != null && val.isValidName) {
      _name = ValidationModel(val, null);
    } else {
      _name = ValidationModel(null, 'Please enter a valid name');
    }
    notifyListeners();
  }

  bool get isEmailValid {
    // return _email.value != null &&
    //     _password.value != null &&
    //     _phone.value != null &&
    //     _name.value != null;

    return _email.value != null;
  }

  bool get isPasswordValid {
    return _password.value != null;
  }

  bool get isDOBValid => _dob.value != null;

}

class ValidationModel {
  String? value;
  String? error;

  ValidationModel(this.value, this.error);
}
