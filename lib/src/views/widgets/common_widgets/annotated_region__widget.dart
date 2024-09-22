import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmptiveAnnotatedRegionWidget extends StatelessWidget {
  final Widget child;

  const AmptiveAnnotatedRegionWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: AmptiveColors.black,
        statusBarColor: AmptiveColors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light
      ),
      child: child
    );
  }
}