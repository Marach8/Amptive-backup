import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

class ATDivider extends StatelessWidget {
  const ATDivider({
    super.key,
    this.axis = AxisType.horizontal,
    this.height
  });

  final AxisType? axis;
  final double? height;

  @override
  Widget build(context) {
    final isHorizontal = axis == AxisType.horizontal;
    return Container(
      color: ATColors.white.withValues(alpha: 0.1),
      height: isHorizontal ? 0.5 : height,
      width: isHorizontal ? ATHelperFuncs.getScreenWidth(context) : 0.5,
      child: const SizedBox.shrink(),
    );
  }
}

enum AxisType {vertical, horizontal}