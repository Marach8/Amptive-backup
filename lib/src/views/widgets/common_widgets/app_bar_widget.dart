import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_leading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AmptiveAppBar({
    super.key,
    this.title,
    this.leading,
    this.hideLeading,
    this.centerTitle = true,
    this.actions,
    this.leadingWidth = 60.0,
    this.bgColor
  });

  final Widget? title, leading;
  final bool? centerTitle, hideLeading;
  final List<Widget>? actions;
  final double? leadingWidth;
  final Color? bgColor;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bgColor ?? AmptiveColors.black,
        elevation: 0.0,
        centerTitle: centerTitle,
        leading: hideLeading ?? false ? null : leading ?? const AmptiveAppBarLeadingWidget(),
        title: title,
        leadingWidth: leadingWidth,
        actions: actions
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}

