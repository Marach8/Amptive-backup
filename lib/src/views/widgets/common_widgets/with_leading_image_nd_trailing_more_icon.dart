import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';

class WidgetWithLeadingImageAndTrailingMoreIcon extends StatelessWidget {
  const WidgetWithLeadingImageAndTrailingMoreIcon({
    super.key,
    required this.title,
    required this.subtitle,
    required this.btnText,
    required this.leadingImgPath,
    required this.btnOnTap,
    required this.trailingMoreOnTap,
    this.bottomTrailingWidget,
    this.imgSize,
    this.bottomTrailingText
  });

  final String title, subtitle, btnText, leadingImgPath;
  final VoidCallback? btnOnTap, trailingMoreOnTap;
  final Widget? bottomTrailingWidget;
  final String? bottomTrailingText;
  final double? imgSize;

  @override
  Widget build(context) {
    return ATContainer(
      color: ATColors.hex9E9E9E.withValues(alpha: 0.3),
      radius: 14, alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              ATImgLoader(imgPath: leadingImgPath, height: imgSize, width: imgSize,),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size15
                      ),
                    ),
                    Text(
                      subtitle, maxLines: 3,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: ATFontSizes.size13
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
    
              IconButton(
                onPressed: trailingMoreOnTap,
                icon: const Icon(Icons.more_horiz),
              )
            ],
          ),
          const SizedBox(height: 10),
          const ATDivider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: btnOnTap,
                  borderRadius: BorderRadius.circular(5),
                  child: ATContainer(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    color: ATColors.white.withValues(alpha: 0.1),
                    radius: 5,
                    child: Text(
                      btnText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size12,
                        color: ATColors.white.withValues(alpha: 0.7)
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: bottomTrailingWidget == null ? Text(
                    bottomTrailingText ?? '', maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ATFontSizes.size14
                    ),
                  ) : bottomTrailingWidget!,
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}

