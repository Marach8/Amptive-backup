import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_btn/loading_btn.dart';

class CustomLoaderButton extends StatelessWidget {
  const CustomLoaderButton({
    super.key,
    required this.width,
    required this.onTap,
    required this.height,
    required this.borderRadius,
    this.color,
    required this.childText,
    this.validCondition = false,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color? color;
  final String childText;
  final Future<void> Function(dynamic start, dynamic stop, dynamic state) onTap;
  final bool? validCondition;

  @override
  Widget build(BuildContext context) {
    return LoadingBtn(
      width: width,
      height: height,
      borderRadius: borderRadius,
      onTap: onTap,
      color: color ??
          (validCondition ?? false
              ? ATColors.hex307FE2
              : const Color(0xFF2F2F2F)),
      loader: SizedBox(
        width: 25.w,
        height: 25.w,
        child: CircularProgressIndicator(
          color: ATColors.white,
          backgroundColor: ATColors.white.withOpacity(0.5),
          strokeWidth: 3.w,
        ),
      ),
      child: Text(
        childText,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: validCondition ?? false
              ? ATColors.white
              : const Color(0xFF666666),
        ),
      ),
    );
  }
}

class AmptiveLoadingButtonWidget extends StatelessWidget {
  const AmptiveLoadingButtonWidget({
    super.key,
    this.margin,
  });

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
      width: double.infinity,
      height: 50.w,
      child: ElevatedButton(
        onPressed: () {},
        child: SizedBox(
          width: 25.w,
          height: 25.w,
          child: CircularProgressIndicator(
            color: ATColors.white,
            backgroundColor: ATColors.white.withOpacity(0.5),
            strokeWidth: 3.w,
          ),
        ),
      ),
    );
  }
}
