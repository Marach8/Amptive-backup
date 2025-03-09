import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';

class ATRoundedImage extends StatelessWidget {
  final String imagePath;
  final double? diameter, picturePadding, borderWidth;
  final Color? borderColor;
  final bool? addBorder;
  final VoidCallback? onTap;

  const ATRoundedImage({
    super.key,
    required this.imagePath,
    this.diameter,
    this.picturePadding, 
    this.borderWidth,
    this.borderColor,
    this.addBorder,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      height: diameter ?? 30,
      width: diameter ?? 30,
      radius: (diameter ?? 30)/2,
      padding: EdgeInsets.all(picturePadding ?? 0),
      border: addBorder ?? false ? Border.all(
        color: borderColor ?? ATColors.whiteColor,
        width: borderWidth ?? 0.5,
      ) : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular((diameter ?? 30)/2),
        child: AmptiveImageLoaderWidget(
          imagePath: imagePath,
          boxFit: BoxFit.cover,
          height: diameter ?? 30,
          width: diameter ?? 30,
        ),
      ),
    );
  }
}
