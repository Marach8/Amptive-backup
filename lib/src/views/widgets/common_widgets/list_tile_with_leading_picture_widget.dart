import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:flutter/material.dart';

class TileWithLeadingImage extends StatelessWidget {

  const TileWithLeadingImage({
    super.key,
    this.trailingOnPressed,
    required this.title,
    required this.subtitle,
    this.padding,
    this.diameter,
    required this.leadingImagePath
  });

  final VoidCallback? trailingOnPressed;
  final String title, subtitle, leadingImagePath;
  final EdgeInsetsGeometry? padding;
  final double? diameter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(0, 15, 0, 10),
      child: Row(
        children: <Widget>[
          ATCircularImage(
            imagePath: leadingImagePath,
            diameter: diameter ?? 40,
          ),
          const SizedBox(width: 12,),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: ATFontWeights.w500,
                ),
              ),
              Text(
                subtitle,
                style: context.textTheme.titleLarge?.copyWith(
                  color: ATColors.hexC2C2C2,
                  fontSize: ATSizes.size12,
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
