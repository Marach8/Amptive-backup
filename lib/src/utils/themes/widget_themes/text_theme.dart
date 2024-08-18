import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';

class AmptiveTextTheme{
  const AmptiveTextTheme._();

  static TextTheme darkTextTheme = TextTheme( 
 
    displayMedium: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size25,
      fontWeight: AmptiveFontWeights.bold,
      letterSpacing: 0.1
    ),

    headlineLarge: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size22,
      fontWeight: AmptiveFontWeights.bold,
    ),

    headlineMedium: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size18,
      fontWeight: AmptiveFontWeights.bold,
    ),

    bodyMedium : TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size16,
      fontWeight: AmptiveFontWeights.semiBold,
    ), 

    bodySmall : TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size14,
      fontWeight: AmptiveFontWeights.medium,
    ),
    
    labelMedium: TextStyle(
      color: AmptiveColors.authHintColor,
      fontSize: AmptiveFontSizes.size16,
      fontWeight: AmptiveFontWeights.regular,
    ),

    titleMedium: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size14,
      fontWeight: AmptiveFontWeights.regular,
    ),

    titleSmall: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size12,
      fontWeight: AmptiveFontWeights.regular,
    ),
  );


  //implement lightTextTheme here
}