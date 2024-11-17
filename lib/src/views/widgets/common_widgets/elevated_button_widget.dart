import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveElevatedButtonWidget extends StatelessWidget {
  final String? buttonTitle, text1, text2;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Color? bgColor, fgColor;
  final ButtonStyle? buttonStyle;

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
  });

  @override
  Widget build(context) {
    final shouldAddMiddleDot = text1 != null && text2 != null;
    return AmptiveCustomContainer(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
      width: double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
          onPressed: onPressed,
          style: buttonStyle ?? ElevatedButton.styleFrom(
              foregroundColor: fgColor, backgroundColor: bgColor),
          child: shouldAddMiddleDot
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text1!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AmptiveColors.brandBlackColor)),
                    const Gap(5),
                    CircleAvatar(
                      radius: 2,
                      backgroundColor: AmptiveColors.brandBlackColor,
                    ),
                    const Gap(5),
                    Text(text2!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AmptiveColors.brandBlackColor)),
                  ],
                )
              : Text(buttonTitle!)),
    );
  }
}
