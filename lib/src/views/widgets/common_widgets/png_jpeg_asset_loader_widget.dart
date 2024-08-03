import 'package:flutter/material.dart';

class AmptivePngAndJpegAssetLoaderWidget extends StatelessWidget {
  final String pngOrJpegPath;
  final BoxFit boxFit;
  final double? height, width;

  const AmptivePngAndJpegAssetLoaderWidget({
    super.key,
    required this.pngOrJpegPath,
    this.height,
    this.width,
    this.boxFit = BoxFit.contain
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      pngOrJpegPath,
      fit: boxFit,
      height: height,
      width: width,
    );
  }
}