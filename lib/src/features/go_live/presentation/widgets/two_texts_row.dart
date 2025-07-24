import 'package:flutter/material.dart';

import '../../../../config/config_export.dart';

class RowWith2Texts extends StatelessWidget {
  const RowWith2Texts({
    super.key,
    required this.text1,
    this.text2 = '',
    this.text1Style,
    this.text2Style,
  });

  final String text1, text2;
  final TextStyle? text1Style, text2Style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text1,
          style: text1Style ?? Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: ATFontWeights.w500
          ),
        ),
        Text(
          text2,
          style: text1Style ?? Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ATColors.white.withValues(alpha: 0.4),
            height: 1.78
          ),
        ),
      ],
    );
  }
}