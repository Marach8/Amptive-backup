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
    this.padding,
    this.side,
    this.isLoading = false,
    this.showBackgroundGradient = true,
  });

  final VoidCallback? onPressed;
  final String? btnTitle;
  final Widget? child;
  final Color? bgColor, fgColor;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderSide? side;
  final bool isLoading;
  final bool showBackgroundGradient;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      height: height ?? 110,
      gradient: showBackgroundGradient
          ? LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.transparent,
                ATColors.hex0D0D0D,
              ],
            )
          : null,
      padding: padding ?? const EdgeInsets.fromLTRB(15, 10, 15, 50),
      child: ATPlainElevatedBtn(
        isLoading: isLoading,
        bgColor: bgColor ?? ATColors.white,
        fgColor: fgColor ?? ATColors.hex0D0D0D,
        side: side,
        btnTitle: btnTitle,
        onPressed: onPressed,
        style: context.textTheme.bodyMedium?.copyWith(
          color: fgColor ?? ATColors.hex0D0D0D,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        child: child,
      ),
    );
  }
}
