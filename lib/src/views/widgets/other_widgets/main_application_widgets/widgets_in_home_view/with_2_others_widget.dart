import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveWith2OthersWidget extends StatelessWidget {
  const AmptiveWith2OthersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: AmptiveColors.black.withOpacity(0.7)
      ),
      child: Text(
        'with 2 others',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: AmptiveFontWeights.medium,
          fontSize: AmptiveFontSizes.size13,
          height: 1.sp,
        )
      )
    );
  }
}
