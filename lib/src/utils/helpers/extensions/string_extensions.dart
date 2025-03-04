import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:intl/intl.dart';

extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName{
    final nameRegExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword{
    final passwordRegExp =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull{
    return this!=null;
  }

  bool get isValidPhone{
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidUsername {
    // Regular expression to match only letters, numbers, periods, and underscores
    final validCharacters = RegExp(r'^[a-z0-9._]+$');
    return validCharacters.hasMatch(this);
  }

  
  bool get emailContainsEmailSymbol => contains(ATStrings.emailSymbol);


  String formatPrice(){
    final number = double.tryParse(this) ?? 0000;
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }


  String get addSlash => '/$this';

}
