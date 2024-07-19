import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveElevatedButtonTheme{
  const AmptiveElevatedButtonTheme._();

  static ElevatedButtonThemeData darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AmptiveColors.whiteColor,
      backgroundColor: AmptiveColors.brandBlueColor,
      disabledForegroundColor: AmptiveColors.grey3Color,
      disabledBackgroundColor: AmptiveColors.transparentColor,
      textStyle: TextStyle(
        fontFamily: AmptiveOtherStrings.inter,
        fontSize: AmptiveFontSizes.size16,
        fontWeight: AmptiveFontWeights.semiBold
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40).r)
    )
  );

  //lightTheme will be implemented here
}