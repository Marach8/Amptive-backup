import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/font_sizes.dart';


class ATScaleUpAndDownWidget extends StatelessWidget {
  const ATScaleUpAndDownWidget({
    super.key,
    required this.imgPath,
    required this.subtitle,
    required this.title,
    required this.isSelected,
    required this.onTap
  });

  final String imgPath,
  title, subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ATContainer(
            duration: 200, height: 120, radius: 5,
            clipBehavior: Clip.hardEdge,
            width: double.infinity,
            color: isSelected ? ATColors.hex307FE2 : ATColors.hex2D2D2D,
            child: AnimatedScale(
              scale: isSelected ? 2 : 1,
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: ATImgLoader(
                  key: Key(subtitle),
                  imgPath: imgPath,
                  boxFit: BoxFit.fill,
                ),
              ),
            )
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: ATFontSizes.size13
            ),
          ),
          const SizedBox(height: 5),
          Text(
            maxLines: 2,
            subtitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: ATColors.hexC2C2C2
            ),
          )
        ],
      ),
    );
  }
}