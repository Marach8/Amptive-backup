import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Required";
    } else if (EmailValidator.validate(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }
}
