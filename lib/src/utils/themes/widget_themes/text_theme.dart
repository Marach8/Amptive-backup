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
      letterSpacing: 0.1,
      overflow: TextOverflow.ellipsis
    ),

    headlineLarge: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size22,
      fontWeight: AmptiveFontWeights.bold,
      overflow: TextOverflow.ellipsis
    ),

    headlineMedium: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size18,
      fontWeight: AmptiveFontWeights.bold,
      overflow: TextOverflow.ellipsis
    ),

    bodyLarge : TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size18,
      fontWeight: AmptiveFontWeights.semiBold,
      overflow: TextOverflow.ellipsis
    ),

    bodyMedium : TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size16,
      fontWeight: AmptiveFontWeights.semiBold,
      overflow: TextOverflow.ellipsis
    ), 

    bodySmall : TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size14,
      fontWeight: AmptiveFontWeights.medium,
      overflow: TextOverflow.ellipsis
    ),
    
    labelMedium: TextStyle(
      color: AmptiveColors.authHintColor,
      fontSize: AmptiveFontSizes.size16,
      fontWeight: AmptiveFontWeights.regular,
      overflow: TextOverflow.ellipsis
    ),

    titleLarge: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size15,
      fontWeight: AmptiveFontWeights.regular,
      overflow: TextOverflow.ellipsis
    ),

    titleMedium: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size14,
      fontWeight: AmptiveFontWeights.regular,
      overflow: TextOverflow.ellipsis
    ),

    titleSmall: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size12,
      fontWeight: AmptiveFontWeights.regular,
      overflow: TextOverflow.ellipsis
    ),
  );


  //implement lightTextTheme here
}