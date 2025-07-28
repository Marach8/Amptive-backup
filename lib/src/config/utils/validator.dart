import 'package:amptive/src/config/config_export.dart';
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


mixin ATValidators{
  String? validateUrl(String? value){
    final RegExp strictUrlRegex = RegExp(
      r'^https?:\/\/(?:www\.)?' // http:// or https:// + optional www.
      r'[-\w@:%._\+~#=]{1,256}\.' // subdomains
      r'[a-z]{2,63}' // main domain
      r'\b(?:[-\w()@:%_\+.~#?&\/=]*)$', // path and parameters
      caseSensitive: false,
    );
    if(strictUrlRegex.hasMatch(value ?? '')){
      return null;
    }
    return ATStrings.ENTER_VALID_URL;
  }
}