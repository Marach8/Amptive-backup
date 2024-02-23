import 'package:amptive/utils/utils.dart';
import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  ValidationModel _email = ValidationModel(null, null);
  ValidationModel _customEmailStatus =
      ValidationModel("This email will be verified in the next step.", null);

  ValidationModel _password =
      ValidationModel(null, "Your password should be at least 8 characters.");
  ValidationModel _name = ValidationModel(null, null);

  DateTime? _dob;

  OTPModel otpModel = OTPModel();

  ValidationModel get email => _email;

  DateTime? get dob => _dob;

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

  void setDOB(DateTime? val) {
    _dob = val;
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
    return _email.value != null;
  }

  bool get isPasswordValid {
    return _password.value != null;
  }

  bool get isDOBValid => _dob != null;

  bool get isOTPValid {
    return otpModel.pin1 != null &&
        otpModel.pin2 != null &&
        otpModel.pin3 != null &&
        otpModel.pin4 != null &&
        otpModel.pin1!.isNotEmpty &&
        otpModel.pin2!.isNotEmpty &&
        otpModel.pin3!.isNotEmpty &&
        otpModel.pin4!.isNotEmpty;
  }

  void setOtp(String pin, int index) {
    if (index == 0) {
      otpModel.pin1 = pin;
    } else if (index == 1) {
      otpModel.pin2 = pin;
    } else if (index == 2) {
      otpModel.pin3 = pin;
    } else if (index == 3) {
      otpModel.pin4 = pin;
    }

    notifyListeners();
  }
}

class ValidationModel {
  String? value;
  String? error;

  ValidationModel(this.value, this.error);
}

class OTPModel {
  String? pin1;
  String? pin2;
  String? pin3;
  String? pin4;
}
