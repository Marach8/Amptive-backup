import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ATBackBtn extends StatelessWidget {
  final String? leadingText;
  final TextStyle? leadingStyle;
  final double? iconSize;
  const ATBackBtn({
    super.key,
    this.leadingText,
    this.leadingStyle,
    this.iconSize
  });

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, size: iconSize ?? 20),
          Text(
            leadingText ?? ATStrings.back,
            style: leadingStyle ?? Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}