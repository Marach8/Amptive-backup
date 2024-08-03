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
    this.leadingWidth
  });

  final Widget? title, leading;
  final bool? centerTitle, hideLeading;
  final List<Widget>? actions;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AmptiveColors.brandBlackColor,
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

