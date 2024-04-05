import 'package:amptive/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_btn/loading_btn.dart';

class CustomLoaderButton extends StatelessWidget {
  CustomLoaderButton({
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
  bool validCondition = false;

  @override
  Widget build(BuildContext context) {
    return LoadingBtn(
      width: width,
      height: height,
      borderRadius: borderRadius,
      onTap: onTap,
      color: color ??
          (validCondition ? AmpColors.brandBlue : const Color(0xFF2F2F2F)),
      loader: SizedBox(
        width: 25.w,
        height: 25.w,
        child: CircularProgressIndicator(
          color: AmpColors.white,
          backgroundColor: AmpColors.white.withOpacity(0.5),
          strokeWidth: 3.w,
        ),
      ),
      child: Text(
        childText,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: validCondition ? AmpColors.white : const Color(0xFF666666),
        ),
      ),
    );
  }
}
