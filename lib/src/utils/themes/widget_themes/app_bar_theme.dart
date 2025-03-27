


import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';

class AmptiveAppBarTheme{
  const AmptiveAppBarTheme._();

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: ATColors.black,
    foregroundColor: ATColors.white,
    titleTextStyle: TextStyle(
      fontFamily: ATStrings.inter,
      fontSize: ATFontSizes.size20,
      fontWeight: ATFontWeights.w700,
    )
  );


  //lightTheme will be implemented here
}
