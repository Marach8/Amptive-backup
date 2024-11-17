import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';

class AmptiveCircularContainerWithPictureWidget extends StatelessWidget {
  final String imagePath;
  final double? diameter, picturePadding, borderWidth;
  final Color? borderColor;
  final bool? addBorder;

  const AmptiveCircularContainerWithPictureWidget({
    super.key,
    required this.imagePath,
    this.diameter,
    this.picturePadding, 
    this.borderWidth,
    this.borderColor,
    this.addBorder
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveCustomContainer(
      height: diameter ?? 30,
      width: diameter ?? 30,
      radius: (diameter ?? 30)/2,
      border: addBorder ?? false ? Border.all(
        color: borderColor ?? AmptiveColors.whiteColor,
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
