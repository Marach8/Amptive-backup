import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';

class AmptiveTextTheme{
  const AmptiveTextTheme._();

  static TextTheme darkTextTheme = TextTheme( 
 
    displayMedium: TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size25,
      fontWeight: AmptiveFontWeights.w700,
      letterSpacing: 0.1,
      overflow: TextOverflow.ellipsis
    ),

    headlineLarge: TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size22,
      fontWeight: AmptiveFontWeights.w700,
      overflow: TextOverflow.ellipsis
    ),

    headlineMedium: TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size18,
      fontWeight: AmptiveFontWeights.w700,
      overflow: TextOverflow.ellipsis
    ),

    bodyLarge : TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size18,
      fontWeight: AmptiveFontWeights.w600,
      overflow: TextOverflow.ellipsis
    ),

    bodyMedium : TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size16,
      fontWeight: AmptiveFontWeights.w600,
      overflow: TextOverflow.ellipsis
    ), 

    bodySmall : TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size14,
      fontWeight: AmptiveFontWeights.w500,
      overflow: TextOverflow.ellipsis
    ),
    
    labelMedium: TextStyle(
      color: ATColors.authHintColor,
      fontSize: ATFontSizes.size16,
      fontWeight: AmptiveFontWeights.w400,
      overflow: TextOverflow.ellipsis
    ),

    labelSmall: TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size18,
      fontWeight: AmptiveFontWeights.w400,
      overflow: TextOverflow.ellipsis
    ),

    titleLarge: TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size15,
      fontWeight: AmptiveFontWeights.w400,
      overflow: TextOverflow.ellipsis
    ),

    titleMedium: TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size14,
      fontWeight: AmptiveFontWeights.w400,
      overflow: TextOverflow.ellipsis
    ),

    titleSmall: TextStyle(
      color: ATColors.white,
      fontSize: ATFontSizes.size12,
      fontWeight: AmptiveFontWeights.w400,
      overflow: TextOverflow.ellipsis
    ),
  );


  //implement lightTextTheme here
}