

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/themes/widget_themes/app_bar_theme.dart';
import 'package:amptive/src/utils/themes/widget_themes/elevated_button_theme.dart';
import 'package:amptive/src/utils/themes/widget_themes/icon_theme.dart';
import 'package:amptive/src/utils/themes/widget_themes/outlined_button_theme.dart';
import 'package:amptive/src/utils/themes/widget_themes/text_theme.dart';
import 'package:amptive/src/utils/themes/widget_themes/textbutton_theme.dart';
import 'package:flutter/material.dart';

class AmptiveThemeData{
  const AmptiveThemeData._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AmptiveOtherStrings.inter,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AmptiveColors.brandBlackColor,
    // listTileTheme: AmptiveListTileTheme.darkListTileTheme,
    textTheme: AmptiveTextTheme.darkTextTheme,
    elevatedButtonTheme: AmptiveElevatedButtonTheme.darkElevatedButtonTheme,
    textButtonTheme: AmptiveTextButtonTheme.darkTextButtonTheme,
    appBarTheme: AmptiveAppBarTheme.darkAppBarTheme,
    iconTheme: AmptiveIconTheme.darkIconTheme,
    // checkboxTheme: AmptiveCheckBoxTheme.darkCheckBoxTheme,
    // inputDecorationTheme: AmptiveInputDecorationTheme.darkInputDecorationTheme,
    outlinedButtonTheme: AmptiveOutlinedButtonTheme.darkOutlinedButtonTheme,
    // datePickerTheme: AmptiveDatePickerTheme.darkDatePickerTheme
  );


  //lightTheme will be added here when the need arises
}
