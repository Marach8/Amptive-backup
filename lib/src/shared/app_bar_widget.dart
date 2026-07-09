import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:flutter/material.dart';

class ATAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ATAppBar(
      {super.key,
      this.title,
      this.leading,
      this.centerTitle = true,
      this.actions,
      this.leadingWidth = 60.0,
      this.bgColor,
      this.titleStyle,
      this.titleText,
      this.titleSpacing,
      this.toolbarHeight,
      this.padding,
      this.bottom});

  final Widget? title, leading;
  final String? titleText;
  final TextStyle? titleStyle;
  final bool? centerTitle;
  final List<Widget>? actions;
  final double? leadingWidth;
  final double? titleSpacing;
  final double? toolbarHeight;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bgColor ?? ATColors.black,
        elevation: 0.0,
        centerTitle: centerTitle,
        leading: leading,
        title: title ??
            Text(titleText ?? '',
                style: titleStyle ?? context.textTheme.bodyMedium),
        leadingWidth: leadingWidth,
        titleSpacing: titleSpacing,
        toolbarHeight: toolbarHeight,
        actions: actions,
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize {
    final double bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight((toolbarHeight ?? kToolbarHeight) + bottomHeight);
  }
}

class ATSliverAppBar extends StatelessWidget {
  const ATSliverAppBar(
      {super.key,
      this.title,
      this.leading,
      this.centerTitle = true,
      this.actions,
      this.leadingWidth = 40.0,
      this.bgColor,
      this.titleStyle,
      this.titleText,
      this.padding,
      this.bottom});

  final Widget? title, leading;
  final String? titleText;
  final TextStyle? titleStyle;
  final bool? centerTitle;
  final List<Widget>? actions;
  final double? leadingWidth;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: bgColor ?? ATColors.black,
      elevation: 0.0,
      centerTitle: centerTitle,
      leading: leading ??
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: ATRoundedBackBtn(),
          ),
      title: title ??
          Text(titleText ?? '',
              style: titleStyle ?? context.textTheme.bodyMedium),
      leadingWidth: leadingWidth,
      actions: actions,
      bottom: bottom,
    );
  }
}
