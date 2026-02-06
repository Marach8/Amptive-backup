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


  String? validateField(String? text){
    if(text == null || text.isEmpty){
      return ATStrings.emptyField;
    }
    return null;
  }

  // String? validateUsername(String? username){
  //   final RegExp regex = RegExp(r'^[a-zA-Z0-9_]{3,30}$');
    
  //   if(username == null || username.isEmpty){
  //     return ATStrings.EMPTY_FIELD;
  //   }
  //   else if(!regex.hasMatch(username)){
  //     return ATStrings.INVALID_USERNAME;
  //   }
  //   return null;
  // }

  String? validatePassword(String? password){
    final RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
    
    if(password == null || password.isEmpty){
      return ATStrings.emptyField;
    }
    else if(!regex.hasMatch(password)){
      return ATStrings.WEAK_PSWRD;
    }
    return null;
  }

  String? validateEmail(String? email){
    final RegExp regexExpression = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if(email == null || email.isEmpty){
      return ATStrings.emptyField;
    }
    else if(!regexExpression.hasMatch(email)){
      return ATStrings.invalidEmail;
    }
    return null;
  }
}

