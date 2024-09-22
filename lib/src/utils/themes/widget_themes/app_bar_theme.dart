


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
    backgroundColor: AmptiveColors.black,
    foregroundColor: AmptiveColors.whiteColor,
    titleTextStyle: TextStyle(
      fontFamily: AmptiveOtherStrings.inter,
      fontSize: AmptiveFontSizes.size20,
      fontWeight: AmptiveFontWeights.bold,
    )
  );


  //lightTheme will be implemented here
}
