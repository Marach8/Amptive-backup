import 'package:flutter/material.dart';

abstract final class AmpColors {
  static const Color transparent = Colors.transparent;

  static const Color white = Colors.white;

  static const Color offWhite = Color(0xFFE7E7E7);

  static const brandBlack = Color(0xFF0D0D0D);

  static const brandBlue = Color(0xFF307FE2);

  static const gray1 = Color(0xFF2D2D2D);

  static const gray2 = Color(0xFF414141);

  static const gray3 = Color(0xFF5C5C5C);

  static const strokeGray = Color(0xFF838383);

  static const dotActive = Color(0xFFD9D9D9);

  static const dotInActive = Color(0xFF5B5B5B);

  static const textRed = Color(0xFFD93535);

  static const authHintColor =  Color(0xFFB6B6B6);

  static const success = Color(0xFF54C981);
}

class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);
}



extension extString on String {
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

}
