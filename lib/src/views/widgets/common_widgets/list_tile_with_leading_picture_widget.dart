import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveListTileWithLeadingPictureWidget extends StatelessWidget {
  final VoidCallback? trailingOnPressed;
  final String title, subtitle, leadingImagePath;
  final EdgeInsetsGeometry? padding;
  final double? diameter;

  const AmptiveListTileWithLeadingPictureWidget({
    super.key,
    this.trailingOnPressed,
    required this.title,
    required this.subtitle,
    this.padding,
    this.diameter,
    required this.leadingImagePath
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(0, 15, 0, 10),
      child: Row(
        children: [
          ATCircularImage(
            imagePath: leadingImagePath,
            diameter: diameter ?? 40,
          ),
          Gap(10.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: ATFontWeights.w500,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ATColors.hexC2C2C2,
                  fontWeight: ATFontWeights.w500,
                  fontSize: ATFontSizes.size13,
                  height: 1.5
                ),
              ),
            ],
          ),
          const Spacer(),
          trailingOnPressed == null ? const SizedBox.shrink() : GestureDetector(
            onTap: trailingOnPressed,
            child: const Icon(Icons.more_horiz, size: 30,),
          )
        ],
      ),
    );
  }
}
