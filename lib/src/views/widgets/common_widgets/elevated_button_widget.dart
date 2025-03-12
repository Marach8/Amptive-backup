import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AmptiveElevatedButtonWidget extends StatelessWidget {
  final String? buttonTitle, text1, text2;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Color? bgColor, fgColor;
  final ButtonStyle? buttonStyle;
  final Widget? child;

  const AmptiveElevatedButtonWidget({
    super.key,
    this.buttonTitle,
    required this.onPressed,
    this.margin,
    this.height,
    this.bgColor,
    this.fgColor,
    this.text1,
    this.text2,
    this.buttonStyle,
    this.child
  });

  @override
  Widget build(context) {
    final shouldAddMiddleDot = text1 != null && text2 != null;
    return ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle ?? ElevatedButton.styleFrom(
          foregroundColor: fgColor,
          backgroundColor: bgColor,
        ),
        child: shouldAddMiddleDot
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(text1!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: ATColors.brandBlack)),
                  const Gap(5),
                  CircleAvatar(
                    radius: 2,
                    backgroundColor: ATColors.brandBlack,
                  ),
                  const Gap(5),
                  Text(text2!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: ATColors.brandBlack)),
                ],
              )
            : Text(buttonTitle!));
  }
}



class ATPlainElevatedBtn extends StatelessWidget {
  final String? btnTitle;
  final VoidCallback onPressed;
  final double? height;
  final Color? bgColor, fgColor;
  final Widget? child;

  const ATPlainElevatedBtn({
    super.key,
    this.btnTitle,
    required this.onPressed,
    this.height,
    this.bgColor,
    this.fgColor,
    this.child
  });

  @override
  Widget build(context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: fgColor,
        backgroundColor: bgColor,
        //padding: const EdgeInsets.fromLTRB(),
        fixedSize: Size(AmptiveHelperFunctions.getScreenWidth(context), height ?? 45)
      ),
      child: child ?? Text(btnTitle ?? ''),
    );
  }
}

