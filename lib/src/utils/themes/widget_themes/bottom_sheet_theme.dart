import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AmptiveBottomSheetTheme{
  const AmptiveBottomSheetTheme._();

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AmptiveColors.transparentColor,
    modalBackgroundColor: AmptiveColors.transparentColor,
    elevation: 0,
    modalElevation: 0,
    modalBarrierColor: AmptiveColors.transparentColor
  );

  //lightTheme will be implemented here
}