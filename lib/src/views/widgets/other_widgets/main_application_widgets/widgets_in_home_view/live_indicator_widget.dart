import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveLiveIndicatorWidget extends StatelessWidget {
  const AmptiveLiveIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      height: 22.h,
      width: 38.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AmptiveColors.orangeColor1,
            AmptiveColors.orangeGradientColorB
          ]
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AmptiveColors.brandBlack,
          width: 2,
        )
      ),
      child: Text(
        AmptiveOtherStrings.LIVE.toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: AmptiveFontWeights.semiBold
        )
      ),
    );
  }
}