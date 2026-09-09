import 'package:amptive/src/config/config_export.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart' show DateFormat;

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    } else if (EmailValidator.validate(value)) {
      return 'Invalid Email';
    } else {
      return null;
    }
  }
}

mixin ATValidators {
  String? validateUrl(String? value) {
    final RegExp strictUrlRegex = RegExp(
      r'^https?:\/\/(?:www\.)?' // http:// or https:// + optional www.
      r'[-\w@:%._\+~#=]{1,256}\.' // subdomains
      r'[a-z]{2,63}' // main domain
      r'\b(?:[-\w()@:%_\+.~#?&\/=]*)$', // path and parameters
      caseSensitive: false,
    );
    if (strictUrlRegex.hasMatch(value ?? '')) {
      return null;
    }
    return ATStrings.ENTER_VALID_URL;
  }

  String? validateField(String? text) {
    if (text == null || text.isEmpty) {
      return ATStrings.emptyField;
    }
    return null;
  }

  String? validateDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date is required';
    }

    try {
      // This enforces: December 15 2018
      DateFormat('MMMM d yyyy').parseStrict(value);
      return null;
    } catch (_) {
      return 'Date must be in the format: December 15 2026';
    }
  }

  String? validatePassword(String? password) {
    final RegExp regex =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');

    if (password == null || password.isEmpty) {
      return ATStrings.emptyField;
    } else if (!regex.hasMatch(password)) {
      return ATStrings.weakPassword;
    }
    return null;
  }

  String? validateEmail(String? email) {
    final RegExp regexExpression =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (email == null || email.isEmpty) {
      return ATStrings.emptyField;
    } else if (!regexExpression.hasMatch(email)) {
      return ATStrings.invalidEmail;
    }
    return null;
  }

  String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return ATStrings.emptyField;
    } else if (phoneNumber.length != 10) {
      return ATStrings.invalidPhone;
    }
    return null;
  }
}
