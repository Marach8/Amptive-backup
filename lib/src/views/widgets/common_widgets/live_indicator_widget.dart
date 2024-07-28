import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveLiveIndicatorWidget extends StatelessWidget {
  const AmptiveLiveIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      height: 23,
      width: 43,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AmptiveColors.orangeGradientColorA,
            AmptiveColors.orangeGradientColorB
          ]
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AmptiveColors.brandBlackColor,
          width: 2,
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 2,
            backgroundColor: AmptiveColors.whiteColor,
          ),
          Gap(3.h),
          Text(
            AmptiveOtherStrings.live.toUpperCase(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: AmptiveFontWeights.semiBold
            )
          ),
        ],
      ),
    );
  }
}