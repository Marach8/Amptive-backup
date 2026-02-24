import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ATImgLoader extends StatelessWidget {
  const ATImgLoader({
    super.key,
    required this.imgPath,
    this.height = 35,
    this.width = 35,
    this.package,
    this.boxFit = BoxFit.contain,
    this.color,
  });

  final String imgPath;
  final String? package;
  final BoxFit boxFit;
  final Color? color;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    if (imgPath.isEmpty) {
      return _ImgErrorWidget(width: width, height: height);
    }

    final String imageExtension = imgPath.split('.').last.toLowerCase();
    final ColorFilter? colorFilter = color == null
      ? null
      : ColorFilter.mode(color ?? ATColors.transparent, BlendMode.srcIn);

    //Network images
    if (imgPath.startsWith('http://') || imgPath.startsWith('https://')) {
      if (imageExtension == 'svg') {
        return SvgPicture.network(
          imgPath,
          fit: boxFit,
          height: height,
          width: width,
          colorFilter: colorFilter,
          placeholderBuilder: (_) => ATShimmer(height: height, width: width),
        );
      }

      return CachedNetworkImage(
        imageUrl: imgPath,
        fit: boxFit,
        height: height,
        width: width,
        color: color,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        memCacheHeight: height != null
            ? (height! * MediaQuery.of(context).devicePixelRatio).round()
            : null,
        placeholder: (_, __) => ATShimmer(height: height, width: width),
        errorWidget: (_, __, ___) =>
            _ImgErrorWidget(width: width, height: height),
      );
    }
    //Asset Images
    else {
      if (imageExtension == 'svg') {
        return SvgPicture.asset(
          imgPath,
          fit: boxFit,
          colorFilter: colorFilter,
          height: height,
          width: width,
        );
      }

      return Image.asset(
        imgPath,
        fit: boxFit,
        height: height,
        width: width,
        color: color,
        package: package,
        errorBuilder: (_, __, ___) =>
            _ImgErrorWidget(width: width, height: height),
      );
    }
  }
}

class _ImgErrorWidget extends StatelessWidget {
  const _ImgErrorWidget({required this.width, required this.height});

  final double? width, height;

  @override
  Widget build(_) {
    return SizedBox(
      height: height,
      width: width,
      child: Icon(Icons.error, size: height != null ? (height! / 2) : null),
    );
  }
}
