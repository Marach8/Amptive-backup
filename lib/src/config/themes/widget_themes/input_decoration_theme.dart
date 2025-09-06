
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:flutter/material.dart';

class AmptiveInputDecorationTheme{
  const AmptiveInputDecorationTheme._();

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 1,
    //isDense: true,
    filled: true,
    fillColor: ATColors.white.withValues(alpha: 0.1),
    // prefixIconColor: AmptiveColors.deepOrange,
    // suffixIconColor: AmptiveColors.deepOrange,
    //labelStyle: const TextStyle().copyWith(fontSize: AmptiveFontSizes.size13),
    hintStyle: TextStyle(
      fontSize: ATSizes.size16,
      color: ATColors.hexB6B6B6,
      fontWeight: ATFontWeights.w400
    ),
    contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
    errorStyle: TextStyle(
      color: ATColors.textRedColor,
      fontSize: ATSizes.size12,
      fontWeight: ATFontWeights.w400
    ),

    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 2)
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 2, color: ATColors.hex307FE2),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 2, color: ATColors.textRedColor),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 2, color: ATColors.textRedColor),
    ),

    disabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: ATColors.trsprnt),
    ),
  );
}