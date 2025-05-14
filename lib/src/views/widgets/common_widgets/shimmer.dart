import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ATShimmer extends StatelessWidget {
  const ATShimmer({
    super.key,
    this.height,
    this.width,
    this.baseColor,
    this.highlightColor,
    this.margin,
    this.radius
  });

  final double? height, width, radius;
  final EdgeInsetsGeometry? margin;
  final Color? highlightColor, baseColor;

  @override
  Widget build(context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? ATColors.white.withValues(alpha: 0.5),
      highlightColor: highlightColor ?? ATColors.hex9E9E9E,
      child: ATContainer(
        margin: margin,
        height: height ?? 40, radius: radius ?? 5,
        color: baseColor ?? ATColors.white.withValues(alpha: 0.5),
        width: width ?? ATHelperFuncs.getScreenWidth(context),
        child: const SizedBox.shrink(),
      )
    );
  }
}