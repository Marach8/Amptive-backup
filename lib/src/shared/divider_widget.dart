import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import '../config/utils/colors.dart';

class ATDivider extends StatelessWidget {
  const ATDivider({
    super.key,
    this.axis = AxisType.horizontal,
    this.height,
  });

  final AxisType? axis;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final bool isHorizontal = axis == AxisType.horizontal;
    return Container(
      color: ATColors.white.withValues(alpha: 0.1),
      height: isHorizontal ? 0.5 : height,
      width: isHorizontal ? context.screenWidth : 0.5,
      child: const SizedBox.shrink(),
    );
  }
}

enum AxisType {vertical, horizontal}