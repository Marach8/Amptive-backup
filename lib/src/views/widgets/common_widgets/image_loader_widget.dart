import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ATImgLoader extends StatelessWidget {
  final String imgPath;
  final String? package;
  final BoxFit boxFit;
  final double? height, width;

  const ATImgLoader({
    super.key,
    required this.imgPath,
    this.height,
    this.width,
    this.package,
    this.boxFit = BoxFit.contain
  });

  @override
  Widget build(BuildContext context) {
    final imageExtension = imgPath.split('.').last;

    if(imageExtension == 'jpg' || imageExtension == 'png' || imageExtension == 'jpeg'){
      return Image.asset(
        imgPath,
        fit: boxFit,
        height: height,
        width: width,
        package: package,
      );
    }

    else if(imageExtension == 'svg'){
      return SvgPicture.asset(
        imgPath, 
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
