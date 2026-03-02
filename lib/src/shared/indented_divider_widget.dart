import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class AmptiveIndentedDividerWidget extends StatelessWidget {
  const AmptiveIndentedDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ATHelperFuncs.getScreenWidth(context);
    final double margin = (screenWidth - 170)/2;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      height: 5,
      width: 170,
      decoration: BoxDecoration(
        color: ATColors.white,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }
}