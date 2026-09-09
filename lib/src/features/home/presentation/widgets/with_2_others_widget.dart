import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class With2OthersWidget extends StatelessWidget {
  const With2OthersWidget({
    super.key,
    this.coHostCount,
  });

  final int? coHostCount;

  String get _coHostText {
    final int count = coHostCount ?? 0;
    if (count == 0) return '';
    if (count == 1) return 'with 1 co-host';
    return 'with $count co-hosts';
  }

  @override
  Widget build(BuildContext context) {
    if (coHostCount == null || coHostCount == 0) return const SizedBox.shrink();
    return Container(
        padding: EdgeInsets.all(6.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: ATColors.black.withValues(alpha: 0.7)),
        child: Text(_coHostText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: ATFontWeights.w500,
                  fontSize: ATSizes.size13,
                  height: 1.sp,
                )));
  }
}
