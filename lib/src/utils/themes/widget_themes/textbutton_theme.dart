import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';

class AmptiveTextButtonTheme{
  const AmptiveTextButtonTheme._();

  static TextButtonThemeData darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      foregroundColor: AmptiveColors.whiteColor,
      backgroundColor: AmptiveColors.transparentColor,
      disabledForegroundColor: AmptiveColors.grey4Color,
      disabledBackgroundColor: AmptiveColors.transparentColor,
      textStyle: TextStyle(
        fontFamily: AmptiveStrings.inter,
        fontSize: AmptiveFontSizes.size16,
        fontWeight: AmptiveFontWeights.w600
      ),
    )
  );


  //Implement for lightTheme here
}