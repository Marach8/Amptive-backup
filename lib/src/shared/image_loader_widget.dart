import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/shimmer.dart';
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
    this.alignment = Alignment.center,
    this.color,
  });

  final String imgPath;
  final String? package;
  final BoxFit boxFit;
  final Alignment alignment;
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
    if (imgPath.startsWith('http')) {
      if (imageExtension == 'svg') {
        return SvgPicture.network(
          imgPath,
          fit: boxFit,
          alignment: alignment,
          height: height,
          width: width,
          colorFilter: colorFilter,
          placeholderBuilder: (_) => ATShimmer(height: height, width: width),
        );
      }

      return CachedNetworkImage(
        imageUrl: imgPath,
        fit: boxFit,
        alignment: alignment,
        height: height,
        width: width,
        color: color,
        filterQuality: FilterQuality.high,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        // memCacheHeight: height != null
        //     ? (height! * MediaQuery.of(context).devicePixelRatio).round()
        //     : null,
        memCacheWidth: width != null
            ? (width! * MediaQuery.of(context).devicePixelRatio).round()
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
          alignment: alignment,
          colorFilter: colorFilter,
          height: height,
          width: width,
        );
      }

      return Image.asset(
        imgPath,
        fit: boxFit,
        alignment: alignment,
        height: height,
        width: width,
        color: color,
        package: package,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) =>
            _ImgErrorWidget(width: width, height: height),
      );
    }
  }
}

/// Neutral placeholder for missing/failed images: a dark tile with a subtle
/// icon, instead of an alarming error glyph.
class _ImgErrorWidget extends StatelessWidget {
  const _ImgErrorWidget({required this.width, required this.height});

  final double? width, height;

  @override
  Widget build(_) {
    return Container(
      height: height,
      width: width,
      color: ATColors.hex252525,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        color: ATColors.hexB6B6B6.withValues(alpha: 0.6),
        size: height != null ? (height! * 0.4) : 20,
      ),
    );
  }
}
