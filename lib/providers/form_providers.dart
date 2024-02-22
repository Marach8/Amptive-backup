import 'package:amptive/utils/utils.dart';
import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  ValidationModel _email = ValidationModel(null, null);
  ValidationModel _customEmailStatus =
      ValidationModel("This email will be verified in the next step.", null);

  ValidationModel _password = ValidationModel(null, null);
  ValidationModel _phone = ValidationModel(null, null);
  ValidationModel _name = ValidationModel(null, null);

  ValidationModel get email => _email;

  ValidationModel get customEmailStatus => _customEmailStatus;

  ValidationModel get password => _password;

  ValidationModel get phone => _phone;

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
    if (val != null && val.isValidPassword) {
      _password = ValidationModel(val, null);
    } else {
      _password = ValidationModel(null,
          'Password must contain an uppercase, lowercase, numeric digit and special character');
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

  void validatePhone(String? val) {
    if (val != null && val.isValidPhone) {
      _phone = ValidationModel(val, null);
    } else {
      _phone = ValidationModel(null, 'Phone Number must be up to 11 digits');
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
}

class ValidationModel {
  String? value;
  String? error;

  ValidationModel(this.value, this.error);
}
