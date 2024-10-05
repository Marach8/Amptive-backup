import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import 'custom_container_widget.dart';

class AmptiveCirceAvatarWidget extends StatelessWidget {
  final double diameter;
  final Color? color;
  final Widget? child;
  final int? animationDuration;
  const AmptiveCirceAvatarWidget({
    super.key,
    required this.diameter,
    this.color,
    this.child,
    this.animationDuration
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveCustomContainer(
      duration: animationDuration,
      height: diameter, width: diameter,
      radius: diameter,
      color: color ?? AmptiveColors.whiteColor,
      child: child ?? const SizedBox.shrink()
    );
  }
}