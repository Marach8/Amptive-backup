import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:flutter/material.dart';

class ATTextTheme{
  const ATTextTheme._();

  static TextTheme darkTextTheme = TextTheme( 
    displayMedium: TextStyle(
      color: ATColors.white,
      fontSize: ATSizes.size25,
      fontWeight: ATFontWeights.w700,
      overflow: TextOverflow.ellipsis,
      letterSpacing: 0
    ),

    displaySmall: TextStyle(
      color: ATColors.white,
      letterSpacing: 0,
      fontSize: ATSizes.size24,
      fontWeight: ATFontWeights.w600,
      overflow: TextOverflow.ellipsis
    ),

    headlineLarge: TextStyle(
      color: ATColors.white,
      fontSize: ATSizes.size22,
      letterSpacing: 0,
      fontWeight: ATFontWeights.w700,
      overflow: TextOverflow.ellipsis
    ),

    headlineMedium: TextStyle(
      color: ATColors.white,
      letterSpacing: 0,
      fontSize: ATSizes.size18,
      fontWeight: ATFontWeights.w700,
      overflow: TextOverflow.ellipsis
    ),

    bodyLarge : TextStyle(
      color: ATColors.white,
      letterSpacing: 0,
      fontSize: ATSizes.size18,
      fontWeight: ATFontWeights.w600,
      overflow: TextOverflow.ellipsis
    ),

    bodyMedium : TextStyle(
      color: ATColors.white,
      letterSpacing: 0,
      fontSize: ATSizes.size16,
      fontWeight: ATFontWeights.w600,
      overflow: TextOverflow.ellipsis
    ), 

    bodySmall : TextStyle(
      color: ATColors.white,
      letterSpacing: 0,
      fontSize: ATSizes.size14,
      fontWeight: ATFontWeights.w500,
      overflow: TextOverflow.ellipsis
    ),
    
    labelMedium: TextStyle(
      color: ATColors.hexB6B6B6,
      letterSpacing: 0,
      fontSize: ATSizes.size16,
      fontWeight: ATFontWeights.w400,
      overflow: TextOverflow.ellipsis
    ),

    labelSmall: TextStyle(
      letterSpacing: 0,
      color: ATColors.white,
      fontSize: ATSizes.size12,
      fontWeight: ATFontWeights.w500,
      overflow: TextOverflow.ellipsis
    ),

    titleLarge: TextStyle(
      letterSpacing: 0,
      color: ATColors.white,
      fontSize: ATSizes.size15,
      fontWeight: ATFontWeights.w400,
      overflow: TextOverflow.ellipsis
    ),

    titleMedium: TextStyle(
      letterSpacing: 0,
      color: ATColors.white,
      fontSize: ATSizes.size14,
      fontWeight: ATFontWeights.w400,
      overflow: TextOverflow.ellipsis
    ),

    titleSmall: TextStyle(
      letterSpacing: 0,
      color: ATColors.white,
      fontSize: ATSizes.size12,
      fontWeight: ATFontWeights.w400,
      overflow: TextOverflow.ellipsis
    ),
  );


  //implement lightTextTheme here
}