import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ATBackBtn extends StatelessWidget {
  const ATBackBtn({
    super.key,
    this.leadingText,
    this.leadingStyle,
    this.iconSize,
    this.alignment,
    this.leadingWidget,
  });
  final String? leadingText;
  final TextStyle? leadingStyle;
  final double? iconSize;
  final AlignmentGeometry? alignment;
  final Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: InkWell(
        onTap: () => context.pop(),
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.arrow_back_ios, size: iconSize ?? 20),
            leadingWidget ?? Text(
              leadingText ?? ATStrings.BACK,
              style: leadingStyle ?? context.textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}



class ATRoundedBackBtn extends StatelessWidget {
  const ATRoundedBackBtn({
    super.key,
    this.bgColor,
    this.splashColor,
    this.icon
  });

  final Color? bgColor, splashColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: bgColor ?? ATColors.black,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: () => context.pop(),
          splashColor: splashColor ?? ATColors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 30, width: 30,
            child: icon ?? const Icon(Icons.keyboard_arrow_left),
          ),
        ),
      ),
    );
  }
}



class ATXBackBtn extends StatelessWidget {
  const ATXBackBtn({super.key, this.onTapOverride});
  final VoidCallback? onTapOverride;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTapOverride ?? () => context.pop(),
        splashColor: ATColors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(30),
        child: const SizedBox(
          height: 30, width: 30,
          child: Icon(Icons.close),
        ),
      ),
    );
  }
}