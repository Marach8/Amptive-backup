import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ATAnnotatedRegion extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;

  const ATAnnotatedRegion({
    super.key,
    required this.child,
    this.statusBarColor
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: ATColors.black,
        statusBarColor: statusBarColor ?? ATColors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light
      ),
      child: child
    );
  }
}