import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveElevatedButtonWidget extends StatelessWidget {
  final String buttonTitle;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Color? bgColor, fgColor;

  const AmptiveElevatedButtonWidget({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    this.margin,
    this.height,
    this.bgColor,
    this.fgColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
      width: double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: fgColor,
          backgroundColor: bgColor
        ),
        child: Text(buttonTitle)
      ),
    );
  }
}
