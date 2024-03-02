import 'package:amptive/utils/utils.dart';
import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  ValidationModel _email = ValidationModel(null, null);
  ValidationModel _customEmailStatus =
      ValidationModel("This email will be verified in the next step.", null);

  ValidationModel _password =
      ValidationModel(null, "Your password should be at least 8 characters.");
  ValidationModel _name = ValidationModel(null, null);
  ValidationModel _username = ValidationModel(null, null);

  DateTime? _dob;

  OTPModel otpModel = OTPModel();

  ValidationModel get email => _email;

  DateTime? get dob => _dob;

  ValidationModel get customEmailStatus => _customEmailStatus;

  ValidationModel get password => _password;

  ValidationModel get name => _name;

  ValidationModel get username => _username;

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
    if (val != null && val.isNotEmpty) {
      _name = ValidationModel(val, null);
    } else {
      _name = ValidationModel(null, '');
    }
    notifyListeners();
  }

  void validateUsername(String? val) {
    if (val != null && val.isNotEmpty) {
      _username = ValidationModel(val, null);
    } else {
      _username = ValidationModel(null, 'Please enter valid username');
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

  bool get isNameValid => _name.value != null;

  bool get isUsernameValid => _username.value != null;

  bool get isOTPValid => otpModel.isOTPValid;

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

  bool get isOTPValid {
    return pin1 != null &&
        pin2 != null &&
        pin3 != null &&
        pin4 != null &&
        pin1!.isNotEmpty &&
        pin2!.isNotEmpty &&
        pin3!.isNotEmpty &&
        pin4!.isNotEmpty;
  }

  int getOTP() {
    if (isOTPValid) {
      String temp = pin1! + pin2! + pin3! + pin4!;
      return int.parse(temp);
    }

    return -1;
  }
}
