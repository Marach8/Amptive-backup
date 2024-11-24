import 'dart:io';

import 'package:flutter/material.dart';

class AnimatedCreateShowSuccessImage extends StatelessWidget {
  const AnimatedCreateShowSuccessImage({
    super.key,
    required double width,
    required double height,
    required this.imageFit,
    required this.imagePath,
  })  : _width = width,
        _height = height;

  final double _width;
  final double _height;
  final BoxFit imageFit;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: _width,
      height: _height,
      curve: Curves.easeInOut,
      child: Image.file(
        File(imagePath),
        height: _height,
        width: _width,
        fit: imageFit,
      ),
    );
  }
}
