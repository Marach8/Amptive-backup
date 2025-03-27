import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AmptiveBottomSheetTheme{
  const AmptiveBottomSheetTheme._();

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: ATColors.trspntColor,
    modalBackgroundColor: ATColors.trspntColor,
    elevation: 0,
    modalElevation: 0,
    modalBarrierColor: ATColors.trspntColor
  );

  //lightTheme will be implemented here
}