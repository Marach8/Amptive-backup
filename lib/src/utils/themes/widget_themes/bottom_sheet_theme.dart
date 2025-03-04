import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AmptiveBottomSheetTheme{
  const AmptiveBottomSheetTheme._();

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: ATColors.transparentColor,
    modalBackgroundColor: ATColors.transparentColor,
    elevation: 0,
    modalElevation: 0,
    modalBarrierColor: ATColors.transparentColor
  );

  //lightTheme will be implemented here
}