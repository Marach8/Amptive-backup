
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveOutlinedButtonTheme{
  const AmptiveOutlinedButtonTheme._();

  static OutlinedButtonThemeData darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: ATColors.white,
      backgroundColor: ATColors.trsprnt,
      disabledForegroundColor: ATColors.hex5B5B5B,
      disabledBackgroundColor: ATColors.trsprnt,
      side: BorderSide(color: ATColors.white, width: 0.5),
      textStyle: TextStyle(
        fontFamily: ATStrings.inter,
        fontSize: ATSizes.size16,
        fontWeight: ATFontWeights.w600
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40).r)
    )
  );

  //Implement for lightTheme here
}