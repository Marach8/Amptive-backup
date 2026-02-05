import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';

class AmptiveTextButtonTheme{
  const AmptiveTextButtonTheme._();

  static TextButtonThemeData darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      foregroundColor: ATColors.white,
      backgroundColor: ATColors.transparent,
      disabledForegroundColor: ATColors.grey4Color,
      disabledBackgroundColor: ATColors.transparent,
      textStyle: TextStyle(
        fontFamily: ATStrings.inter,
        fontSize: ATSizes.size16,
        fontWeight: ATFontWeights.w600
      ),
    )
  );


  //Implement for lightTheme here
}