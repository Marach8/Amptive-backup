import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';

class ATBlurredBgBtn extends StatelessWidget {
  const ATBlurredBgBtn({
    super.key,
    required this.onPressed,
    this.btnTitle,
    this.child,
    this.bgColor,
    this.fgColor,
    this.height,
    this.padding
  });

  final VoidCallback? onPressed;
  final String? btnTitle;
  final Widget? child;
  final Color? bgColor, fgColor;
  final double? height; 
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      height: height ?? 110,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          ATColors.hex0D0D0D.withValues(alpha: 0.1),
          ATColors.hex0D0D0D
        ]
      ),
      padding: padding ?? const EdgeInsets.fromLTRB(15, 10, 15, 50),
      child: ATPlainElevatedBtn(
        bgColor: bgColor ?? ATColors.white,
        fgColor: fgColor ?? ATColors.hex0D0D0D,
        btnTitle: btnTitle,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}