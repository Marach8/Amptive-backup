import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/material.dart';

class AmptiveElevatedButtonWidget extends StatelessWidget {
  const AmptiveElevatedButtonWidget(
      {super.key,
      this.buttonTitle,
      required this.onPressed,
      this.margin,
      this.height,
      this.bgColor,
      this.fgColor,
      this.text1,
      this.text2,
      this.buttonStyle,
      this.child});
  final String? buttonTitle, text1, text2;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Color? bgColor, fgColor;
  final ButtonStyle? buttonStyle;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final bool shouldAddMiddleDot = text1 != null && text2 != null;
    return ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle ??
            ElevatedButton.styleFrom(
              foregroundColor: fgColor,
              backgroundColor: bgColor,
            ),
        child: shouldAddMiddleDot
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(text1!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: ATColors.hex0D0D0D)),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    radius: 2,
                    backgroundColor: ATColors.hex0D0D0D,
                  ),
                  const SizedBox(width: 5),
                  Text(text2!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: ATColors.hex0D0D0D)),
                ],
              )
            : Text(buttonTitle!));
  }
}

class ATPlainElevatedBtn extends StatelessWidget {
  const ATPlainElevatedBtn({
    super.key,
    this.btnTitle,
    required this.onPressed,
    this.padding,
    this.height,
    this.width,
    this.bgColor,
    this.fgColor,
    this.child,
    this.style,
    this.isLoading = false,
  });

  final EdgeInsetsGeometry? padding;
  final String? btnTitle;
  final void Function()? onPressed;
  final double? height, width;
  final Color? bgColor, fgColor;
  final Widget? child;
  final TextStyle? style;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              padding: padding,
              foregroundColor: fgColor,
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              fixedSize: Size(width ?? context.screenWidth, height ?? 54)),
          child: isLoading
              ? ATLoadingIndicator(
                  color: fgColor ?? ATColors.white,
                  size: 30,
                )
              : (child ??
                  Text(
                    btnTitle ?? '',
                    style: style,
                  ))),
    );
  }
}
