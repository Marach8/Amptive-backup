import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import 'custom_container_widget.dart';

class ATCircleAvatar extends StatelessWidget {
  final double diameter;
  final Color? color;
  final Widget? child;
  final int? animationDuration;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  const ATCircleAvatar({
    super.key,
    required this.diameter,
    this.color,
    this.child, this.padding,
    this.animationDuration,
    this.onTap
  });

  @override
  Widget build(context) {
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