import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/opacity_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LiveWithAnimatingDot extends StatelessWidget {
  const LiveWithAnimatingDot({
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
          colors: <Color>[
            ATColors.hexF91880,
            ATColors.orangeGradientColorB
          ]
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ATAnimOpacity(
            child: CircleAvatar(
              radius: 3,
              backgroundColor: ATColors.white,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            ATStrings.LIVE.toUpperCase(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: ATSizes.size14,
              fontWeight: ATFontWeights.w600,
              height: 0,
            )
          ),
        ],
      ),
    );
  }
}