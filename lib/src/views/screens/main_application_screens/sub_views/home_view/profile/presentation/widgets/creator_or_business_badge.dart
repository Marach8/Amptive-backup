import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';

class CreatorOrBizBadge extends StatelessWidget {
  const CreatorOrBizBadge({
    super.key,
    this.width, 
    this.height,
    this.radius,
    this.isCreator = true
  });
  final double? height, width, radius;
  final bool? isCreator;

  @override
  Widget build(context) {
    return ATContainer(
      height: height, width: width,
      color: ATColors.hexFED601,
      radius: radius ?? 10,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 1),
      border: Border.all(color: ATColors.black, width: 2),
      child: Text(
        (isCreator ?? false ? ATStrings.CREATOR : ATStrings.BUSINESS).toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: ATFontSizes.size10,
          color: ATColors.black
        ),
      ),
    );
  }
}
