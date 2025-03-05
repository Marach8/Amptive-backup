
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveInputDecorationTheme{
  const AmptiveInputDecorationTheme._();

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 1,
    //isDense: true,
    filled: true,
    fillColor: ATColors.hex9E9E9E.withOpacity(0.3),
    // prefixIconColor: AmptiveColors.deepOrange,
    // suffixIconColor: AmptiveColors.deepOrange,
    //labelStyle: const TextStyle().copyWith(fontSize: AmptiveFontSizes.size13),
    hintStyle: TextStyle(
      fontSize: AmptiveFontSizes.size16,
      color: ATColors.authHintColor,
      fontWeight: AmptiveFontWeights.w400
    ),
    contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12).r,
    errorStyle: TextStyle(
      color: ATColors.textRedColor,
      fontSize: AmptiveFontSizes.size12,
      fontWeight: AmptiveFontWeights.w400
    ),

    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14).r,
      borderSide: BorderSide(width: 2.r,)
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14).r,
      borderSide: BorderSide(width: 2.r, color: ATColors.hex307FE2),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14).r,
      borderSide: BorderSide(width: 2.r, color: ATColors.textRedColor),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14).r,
      borderSide: BorderSide(width: 2.r, color: ATColors.textRedColor),
    ),

    disabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14).r,
      borderSide: BorderSide(color: ATColors.transparentColor),
    ),
  );
}