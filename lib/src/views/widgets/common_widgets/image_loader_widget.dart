import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AmptiveImageLoaderWidget extends StatelessWidget {
  final String imagePath;
  final String? package;
  final BoxFit boxFit;
  final double? height, width;

  const AmptiveImageLoaderWidget({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.package,
    this.boxFit = BoxFit.contain
  });

  @override
  Widget build(BuildContext context) {
    final imageExtension = imagePath.split('.').last;

    if(imageExtension == 'jpg' || imageExtension == 'png'){
      return Image.asset(
        imagePath,
        fit: boxFit,
        height: height,
        width: width,
        package: package,
      );
    }

    else if(imageExtension == 'svg'){
      return SvgPicture.asset(
      imagePath, 
      fit: boxFit,
      height: height,
      width: width,
      package: package,
    );
    }
    //This should never happen
    else{
      return const SizedBox.shrink();
    }
  }
}