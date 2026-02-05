import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveElevatedButtonTheme{
  const AmptiveElevatedButtonTheme._();

  static ElevatedButtonThemeData darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: ATColors.white,
      backgroundColor: ATColors.hex307FE2,
      disabledForegroundColor: ATColors.hex666666,
      //disabledForegroundColor: ATColors.grey4Color,
      disabledBackgroundColor: ATColors.hex2F2F2F,
      //disabledBackgroundColor: ATColors.hex9E9E9E.withOpacity(0.3),
      textStyle: TextStyle(
        fontFamily: ATStrings.inter,
        fontSize: ATSizes.size17,
        fontWeight: ATFontWeights.w600
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40).r)
    )
  );

  //lightTheme will be implemented here
}