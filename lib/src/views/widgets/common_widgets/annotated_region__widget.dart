import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ATAnnotatedRegion extends StatelessWidget {

  const ATAnnotatedRegion({
    super.key,
    required this.child,
    this.statusBarColor
  });
  final Widget child;
  final Color? statusBarColor;

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