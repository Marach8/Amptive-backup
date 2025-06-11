import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:flutter/material.dart';

class ATOverlappingImages extends StatelessWidget {

  const ATOverlappingImages({
    super.key,
    required this.imgPaths,
    this.imgSize = 20.0,
    this.overlapOffset = 15.0,
    this.borderWidth = 0.5,
    this.borderColor,
  });


  final List<String> imgPaths;
  final double imgSize;
  final Color? borderColor;
  final double overlapOffset, borderWidth;

  @override
  Widget build(BuildContext context) {
    final int length = imgPaths.length;
    final double width = imgSize + ((length - 1) * overlapOffset);

    return SizedBox(
      height: imgSize,
      width: width,
      child: Stack(
        children: imgPaths.map(
          (String imgPath) {
            int index = imgPaths.indexOf(imgPath);

            return Positioned(
              left: index * overlapOffset,
              child: ATCircularImage(
                imagePath: imgPath,
                diameter: imgSize,
                addBorder: true,
                borderColor: borderColor,
                borderWidth: borderWidth,
              ),
            );
          }
        ).toList(),
      ),
    );
  }
}