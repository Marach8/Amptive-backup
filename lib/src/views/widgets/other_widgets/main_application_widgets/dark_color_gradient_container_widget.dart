import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveDarkColorGradientContainerWidget extends StatelessWidget {
  const AmptiveDarkColorGradientContainerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      width: AmptiveHelperFunctions.getScreenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15).r,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AmptiveColors.containerGradientColorA,
            AmptiveColors.containerGradientColorB.withOpacity(0.5),
            AmptiveColors.containerGradientColorB.withOpacity(0.8),
            AmptiveColors.containerGradientColorB.withOpacity(0.9),
            AmptiveColors.containerGradientColorB,
            AmptiveColors.containerGradientColorB,
            AmptiveColors.containerGradientColorB,
            AmptiveColors.containerGradientColorB,
            AmptiveColors.containerGradientColorB,
          ]
        )
      ),
    );
  }
}
