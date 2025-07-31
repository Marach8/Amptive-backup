import 'dart:ui' show ImageFilter;
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
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
        children: imgPaths.indexed.map(
          ((int, String) entry) {
            return Positioned(
              left: entry.$1 * overlapOffset,
              child: ATCircularImage(
                imagePath: entry.$2,
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



class ATOverlappingCircles extends StatelessWidget {

  const ATOverlappingCircles({
    super.key,
    required this.maxNumber,
    this.circleSize = 42.0,
    this.overlapOffset = 32.0,
    this.borderWidth = 1,
    this.borderColor,
  });

  final double circleSize;
  final Color? borderColor;
  final double overlapOffset, borderWidth;
  final int maxNumber;

  @override
  Widget build(BuildContext context) {
    final List<int> numbers = List<int>.generate(maxNumber, (int index) => index);
    final double width = circleSize + ((numbers.length - 1) * overlapOffset);

    return SizedBox(
      height: circleSize,
      width: width,
      child: Stack(
        children: numbers.indexed.map(
          ((int, int) entry) {
            return Positioned(
              left: entry.$1 * overlapOffset,
              child: ATContainer(
                height: circleSize, width: circleSize,
                color: ATColors.black.withValues(alpha: 0.05),
                clipBehavior: Clip.hardEdge,
                radius: circleSize,
                border: Border.all(
                  color: borderColor ?? ATColors.white.withValues(alpha: 0.4),
                  width: borderWidth,
                ) ,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Center(
                      child: Text(
                        (entry.$1 + 1).toString(),
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: ATFontSizes.size11
                        )
                      ),
                    ),
                  )
                ),
              ),
            );
          }
        ).toList(),
      ),
    );
  }
}