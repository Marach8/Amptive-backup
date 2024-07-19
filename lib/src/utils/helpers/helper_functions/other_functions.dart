import 'package:flutter/material.dart';

class AmptiveHelperFunctions{
  const AmptiveHelperFunctions._();

  static double getScreenWidth(BuildContext context)
    => MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context)
    => MediaQuery.of(context).size.height;
}