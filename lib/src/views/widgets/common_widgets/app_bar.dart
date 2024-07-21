import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_leading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AmptiveAppBar({
    super.key,
    this.title,
    this.centerTitle = true
  });

  final Widget? title;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AmptiveColors.brandBlackColor,
        elevation: 0.0,
        centerTitle: centerTitle,
        leading: const AmptiveAppBarLeadingWidget(),
        title: title,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}

