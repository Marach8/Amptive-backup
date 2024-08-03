
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
      foregroundColor: AmptiveColors.whiteColor,
      backgroundColor: AmptiveColors.transparentColor,
      disabledForegroundColor: AmptiveColors.inactiveDotColor,
      disabledBackgroundColor: AmptiveColors.transparentColor,
      side: BorderSide(color: AmptiveColors.whiteColor, width: 0.5),
      textStyle: TextStyle(
        fontFamily: AmptiveOtherStrings.inter,
        fontSize: AmptiveFontSizes.size16,
        fontWeight: AmptiveFontWeights.semiBold
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40).r)
    )
  );

  //Implement for lightTheme here
}