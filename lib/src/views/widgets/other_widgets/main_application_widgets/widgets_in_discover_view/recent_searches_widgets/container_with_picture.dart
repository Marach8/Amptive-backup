import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class AmptivePictureWidget extends StatelessWidget {
  const AmptivePictureWidget({
    super.key,
    required this.imagePath,
    this.radius,
    required this.diameter,
    this.isCircular,
  });
  final String imagePath;
  final double? radius;
  final double diameter;
  final bool? isCircular;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      clipBehavior: Clip.hardEdge,
      height: diameter,
      width: diameter,
      radius: (isCircular ?? false) ? null : radius,
      boxShape: (isCircular ?? false) ? BoxShape.circle : null,
      child: ATImgLoader(imgPath: imagePath, boxFit: BoxFit.cover),
    );
  }
}
