
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveOutlinedButtonTheme{
  const AmptiveOutlinedButtonTheme._();

  static OutlinedButtonThemeData darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: ATColors.whiteColor,
      backgroundColor: ATColors.trspntColor,
      disabledForegroundColor: ATColors.inactiveDotColor,
      disabledBackgroundColor: ATColors.trspntColor,
      side: BorderSide(color: ATColors.whiteColor, width: 0.5),
      textStyle: TextStyle(
        fontFamily: ATStrings.inter,
        fontSize: ATFontSizes.size16,
        fontWeight: AmptiveFontWeights.w600
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40).r)
    )
  );

  //Implement for lightTheme here
}