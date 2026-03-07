import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ATAnnotatedRegion extends StatelessWidget {
  const ATAnnotatedRegion({
    super.key,
    required this.child,
    this.statusBarColor,
    this.systemBarColor,
  });
  final Widget child;
  final Color? statusBarColor, systemBarColor;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            systemNavigationBarColor: systemBarColor ?? ATColors.transparent,
            statusBarColor: statusBarColor ?? ATColors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light),
        child: child);
  }
}
