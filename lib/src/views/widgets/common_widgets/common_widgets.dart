import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
          (validCondition ?? false ? AmptiveColors.brandBlueColor : const Color(0xFF2F2F2F)),
      loader: SizedBox(
        width: 25.w,
        height: 25.w,
        child: CircularProgressIndicator(
          color: AmptiveColors.whiteColor,
          backgroundColor: AmptiveColors.whiteColor.withOpacity(0.5),
          strokeWidth: 3.w,
        ),
      ),
      child: Text(
        childText,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: validCondition ?? false? AmptiveColors.whiteColor : const Color(0xFF666666),
        ),
      ),
    );
  }
}


class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BuildAppBar({
    super.key,
    this.titleWidget,
  });

  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AmptiveColors.brandBlackColor,
      elevation: 0.0,
      leadingWidth: 90.w,
      leading: GestureDetector(
        onTap: ()=> context.pop(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 8.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 8.w),
                width: 20.h,
                height: 20.h,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AmptiveColors.whiteColor,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3.w),
                padding: EdgeInsets.only(top: 1.h),
                child: Text(
                  "Back",
                  style: GoogleFonts.inter(
                    color: AmptiveColors.whiteColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      title: titleWidget,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(44.h);
}

