import 'package:amptive/src/utils/constants/constants.dart';
import 'package:amptive/src/utils/helpers/extensions/extensions.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/src/painting/image_provider.dart';

import '../../models/validation_model.dart';
import '../authentication_service.dart';

class AuthFieldService {
  final AuthenticationService authenticationService;
  ValidationModel _password =
      ValidationModel(null, "Your password should be at least 8 characters.");

  // validation model for authentication form fields
  ValidationModel _email = ValidationModel(null, null);
  ValidationModel _customEmailStatus =
      ValidationModel("This email will be verified in the next step.", null);

  ValidationModel _name = ValidationModel(null, null);
  ValidationModel _username = ValidationModel(null, null);
  ValidationModel _phoneNo = ValidationModel(null, null);

  DateTime? _dob;
  Country _country =
      CountryPickerUtils.getCountryByIsoCode(Constants.kDefaultCountrySelected);

  //getters
  ValidationModel get password => _password;

  bool get isPasswordValid => _password.value != null;

  ValidationModel get email => _email;

  bool get isEmailValid => _email.value != null;

  DateTime? get dob => _dob;

  Country get country => _country;

  ValidationModel get customEmailStatus => _customEmailStatus;

  ValidationModel get name => _name;

  ValidationModel get username => _username;

  ValidationModel get phoneNo => _phoneNo;

  bool get isPhoneValid => _phoneNo.value != null;

  bool get isNameValid => _name.value != null;

  bool get isUsernameValid => _username.value != null;

  bool get isUsernameInvalid => _username.error != null;

  // Class Initializer
  static final AuthFieldService _instance =
      AuthFieldService._(AuthenticationService());

  // constructor
  AuthFieldService._(this.authenticationService);

  factory AuthFieldService() => _instance;

  // setters
  void setDOB(DateTime? val) {
    _dob = val;
  }

  void setCountry(Country c) {
    _country = c;
  }

  // process fields
  Future<bool> processEmail() async {
    final email = _email.value;
    if (await authenticationService.checkUniqueEmail(email!)) {
      _customEmailStatus = ValidationModel("This email already exist!.", null);
      return false;
    } else {
      // send otp
      await authenticationService.sendOTP(email);
      return true;
    }
  }

  // field validators
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
  }

  Future<bool> validateUsername(String? val) async {
    await authenticationService
        .checkUniqueEmail("email@emmil.com"); // to be removed
    if (val != null && !val.isValidUsername) {
      _username = ValidationModel(null,
          'Username must contain only small cap letters, numbers, periods, and underscores.');
      return false;
    } else if (val != null && val.isNotEmpty) {
      if (await authenticationService.checkUniqueUsername(val)) {
        _username = ValidationModel(null, 'Username is taken');
        return false;
      }
      _username = ValidationModel(val, null);
      return true;
    } else {
      _username = ValidationModel(null, 'Please enter valid username');
      return false;
    }
  }

  void validateName(String? val) {
    if (val != null && val.isNotEmpty) {
      _name = ValidationModel(val, null);
    } else {
      _name = ValidationModel(null, '');
    }
  }

  void validatePhoneNumber(String? val) {
    if (val != null && val.length >= 10) {
      _phoneNo = ValidationModel(val, null);
    } else {
      _phoneNo = ValidationModel(null, '');
    }
  }

  void setProfilePicture(MemoryImage image) {}

  void clearProfilePicture() {}
}
