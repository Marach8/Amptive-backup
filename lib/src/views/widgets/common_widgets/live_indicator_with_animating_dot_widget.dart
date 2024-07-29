import 'package:amptive/src/utils/constants/colors.dart';
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
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      height: 20,
      width: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AmptiveColors.orangeGradientColorA,
            AmptiveColors.orangeGradientColorB
          ]
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AmptiveAnimatedOpacityWidget(
            child: CircleAvatar(
              radius: 3,
              backgroundColor: AmptiveColors.whiteColor,
            ),
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