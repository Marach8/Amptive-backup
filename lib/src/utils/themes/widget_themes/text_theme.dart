import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';

class AmptiveTextTheme{
  const AmptiveTextTheme._();

  static TextTheme darkTextTheme = TextTheme( 
 
    displayMedium: TextStyle(
      color: AmptiveColors.whiteColor,
      fontSize: AmptiveFontSizes.size24,
      fontWeight: AmptiveFontWeights.bold,
    ),

    headlineMedium: const TextStyle(
      // color: AmptiveColors.grey100Color,
      // fontSize: AmptiveFontSizes.size14,
      fontWeight: AmptiveFontWeights.medium,
    ),

    bodyMedium : const TextStyle(
      // color: AmptiveColors.grey400Color,
      // fontSize: AmptiveFontSizes.size14,
      fontWeight: AmptiveFontWeights.medium,
    ), 
    
    labelMedium: TextStyle(
      color: AmptiveColors.authHintColor,
      fontSize: AmptiveFontSizes.size16,
      fontWeight: AmptiveFontWeights.regular,
    ),

    titleMedium: TextStyle(
      //color: AmptiveColors.grey100Color,
      fontSize: AmptiveFontSizes.size16,
      fontWeight: AmptiveFontWeights.semiBold,
    ),
  );


  //implement lightTextTheme here
}