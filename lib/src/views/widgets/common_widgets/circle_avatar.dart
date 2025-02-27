import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import 'custom_container_widget.dart';

class AmptiveCircleAvatarWidget extends StatelessWidget {
  final double diameter;
  final Color? color;
  final Widget? child;
  final int? animationDuration;
  final VoidCallback? onTap;
  const AmptiveCircleAvatarWidget({
    super.key,
    required this.diameter,
    this.color,
    this.child,
    this.animationDuration,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveContainer(
      onTap: onTap,
      duration: animationDuration,
      height: diameter, width: diameter,
      radius: diameter,
      color: color ?? AmptiveColors.whiteColor,
      child: child ?? const SizedBox.shrink()
    );
  }
}