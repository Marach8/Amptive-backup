import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class ATCircularImage extends StatelessWidget {
  const ATCircularImage(
      {super.key,
      required this.imagePath,
      this.diameter,
      this.picturePadding,
      this.borderWidth,
      this.borderColor,
      this.addBorder,
      this.onTap});
  final String imagePath;
  final double? diameter, picturePadding, borderWidth;
  final Color? borderColor;
  final bool? addBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      height: diameter ?? 30,
      width: diameter ?? 30,
      boxShape: BoxShape.circle,
      padding: EdgeInsets.all(picturePadding ?? 0),
      border: addBorder ?? false
          ? Border.all(
              color: borderColor ?? ATColors.white,
              width: borderWidth ?? 0.5,
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular((diameter ?? 30) / 2),
        child: ATImgLoader(
          imgPath: imagePath,
          boxFit: BoxFit.cover,
          height: diameter ?? 30,
          width: diameter ?? 30,
        ),
      ),
    );
  }
}
