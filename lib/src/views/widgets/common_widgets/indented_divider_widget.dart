import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:flutter/material.dart';

class AmptiveIndentedDividerWidget extends StatelessWidget {
  const AmptiveIndentedDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = AmptiveHelperFunctions.getScreenWidth(context);
    final margin = (screenWidth - 170)/2;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      height: 5,
      width: 170,
      decoration: BoxDecoration(
        color: AmptiveColors.whiteColor,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }
}