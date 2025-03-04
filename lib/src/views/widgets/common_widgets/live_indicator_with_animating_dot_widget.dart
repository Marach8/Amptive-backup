import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/opacity_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveLiveIndicatorWithAnimatingDotWidget extends StatelessWidget {
  const AmptiveLiveIndicatorWithAnimatingDotWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.44.w, 5.h, 8.44.w, 5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ATColors.orangeColor1,
            ATColors.orangeGradientColorB
          ]
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AmptiveAnimatedOpacityWidget(
            child: CircleAvatar(
              radius: 3.r,
              backgroundColor: ATColors.whiteColor,
            ),
          ),
          Gap(4.w),
          Text(
            ATStrings.LIVE.toUpperCase(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: AmptiveFontSizes.size14,
              fontWeight: AmptiveFontWeights.w600,
              height: 0,
            )
          ),
        ],
      ),
    );
  }
}