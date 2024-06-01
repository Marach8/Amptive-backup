import 'package:amptive/utils/utils.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';

import '../service/authentication_service.dart';

class FormProvider extends ChangeNotifier {
  final AuthenticationService _service = AuthenticationService();

  // validation model for authentication form fields
  ValidationModel _email = ValidationModel(null, null);
  ValidationModel _customEmailStatus =
      ValidationModel("This email will be verified in the next step.", null);

  ValidationModel _password =
      ValidationModel(null, "Your password should be at least 8 characters.");
  ValidationModel _name = ValidationModel(null, null);
  ValidationModel _username = ValidationModel(null, null);
  ValidationModel _phoneNo = ValidationModel(null, null);

  DateTime? _dob;
  Country _country = CountryPickerUtils.getCountryByIsoCode('NG');
  OTPModel otpModel = OTPModel();

  // fields getter
  AuthenticationService get service => _service;

  ValidationModel get email => _email;

  DateTime? get dob => _dob;

  Country get country => _country;

  ValidationModel get customEmailStatus => _customEmailStatus;

  ValidationModel get password => _password;

  ValidationModel get name => _name;

  ValidationModel get username => _username;

  ValidationModel get phoneNo => _phoneNo;

  bool get isEmailValid => _email.value != null;

  bool get isPasswordValid => _password.value != null;

  // process fields
  Future<bool> processEmail() async {
    if (await _service.checkUniqueEmail(_email.value!)) {
      _customEmailStatus = ValidationModel("This email already exist!.", null);
      _email = ValidationModel(null, null);
      notifyListeners();
      return false;
    } else {
      // send otp
      await _service.sendOTP(_email.value!);
      return true;
    }
  }

  void validateEmail(String? val) {
    if (val != null && val.isValidEmail) {
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

  void validatePhoneNumber(String? val) {
    if (val != null && val.length >= 10) {
      _phoneNo = ValidationModel(val, null);
    } else {
      _phoneNo = ValidationModel(null, '');
    }
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

  Future<bool> validateUsername(String? val) async {
    if (val != null && !val.isValidUsername) {
      _username = ValidationModel(null, 'Username must contain only small cap letters, numbers, periods, and underscores.');
      notifyListeners();
      return false;
    } else if (val != null && val.isNotEmpty) {
      if (await _service.checkUniqueUsername(val)) {
        _username = ValidationModel(null, 'Username is taken');
        notifyListeners();
        return false;
      }
      _username = ValidationModel(val, null);
      notifyListeners();
      return true;
    } else {
      _username = ValidationModel(null, 'Please enter valid username');
      notifyListeners();
      return false;
    }
  }

  // fields setter
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

  void setDOB(DateTime? val) {
    _dob = val;
    notifyListeners();
  }

  void setCountry(Country c) {
    _country = c;
    notifyListeners();
  }

  // fields valid checker
  bool get isDOBValid => _dob != null;

  bool get isPhoneValid => _country != null && _phoneNo.value != null;

  bool get isNameValid => _name.value != null;

  bool get isUsernameValid => _username.value != null;

  bool get isUsernameInvalid => _username.error != null;

  bool get isOTPValid => otpModel.isOTPValid;
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
