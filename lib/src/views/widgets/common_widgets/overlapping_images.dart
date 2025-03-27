import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:flutter/material.dart';

class ATOverlappingImages extends StatelessWidget {
  final List<String> imgPaths;
  final double imgSize;
  final double overlapOffset;

  const ATOverlappingImages({
    super.key,
    required this.imgPaths,
    this.imgSize = 20.0,
    this.overlapOffset = 15.0,
  });

  @override
  Widget build(context) {
    final length = imgPaths.length;
    final width = imgSize + ((length - 1) * overlapOffset);

    return SizedBox(
      height: imgSize,
      width: width,
      child: Stack(
        children: imgPaths.map(
          (imgPath) {
            int index = imgPaths.indexOf(imgPath);

            return Positioned(
              left: index * overlapOffset,
              child: ATCircularImage(
                imagePath: imgPath,
                diameter: imgSize,
                addBorder: true,
              ),
            );
          }
        ).toList(),
      ),
    );
  }
}