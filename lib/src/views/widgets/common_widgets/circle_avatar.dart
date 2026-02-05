import 'package:flutter/material.dart';
import '../../../config/utils/colors.dart';
import '../../../shared/custom_container_widget.dart';

class ATCircleAvatar extends StatelessWidget {
  const ATCircleAvatar({
    super.key,
    required this.diameter,
    this.color,
    this.child, this.padding,
    this.animationDuration,
    this.onTap
  });
  final double diameter;
  final Color? color;
  final Widget? child;
  final int? animationDuration;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      padding: padding,
      duration: animationDuration,
      height: diameter, width: diameter,
      radius: diameter,
      color: color ?? ATColors.white,
      child: Center(
        child: FittedBox(
          fit: BoxFit.fill,
          child: child
        ),
      )
    );
  }
}