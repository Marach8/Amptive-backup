import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'dart:ui';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class With2OthersWidget extends StatelessWidget {
  const With2OthersWidget({
    super.key,
    this.coHosts,
    this.onTap,
  });

  final VoidCallback? onTap;

  final List<CoHost>? coHosts;

  String get _coHostText {
    final int count = coHosts?.length ?? 0;
    if (count <= 1) return 'with 1 other'; // Always return text so layout height is preserved when hidden
    return 'with $count others';
  }

  @override
  Widget build(BuildContext context) {
    final bool isVisible = coHosts != null && coHosts!.isNotEmpty;
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Ensures the entire padded area is tappable
      onTap: isVisible ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 16.0), // Expands touch target without breaking visual alignment
        child: Visibility(
          visible: isVisible,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
                padding: EdgeInsets.all(6.h),
                color: ATColors.black.withValues(alpha: 0.55),
                child: Text(_coHostText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: ATFontWeights.w600,
                          fontSize: ATSizes.size13,
                          height: 1.sp,
                        ))),
          ),
        ),
        ),
      ),
    );
  }
}
