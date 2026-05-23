import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/custom_container_widget.dart';

class ATEventOrShowCard extends StatelessWidget {
  const ATEventOrShowCard({
    super.key,
    this.imgPath,
  });

  final String? imgPath;

  @override
  Widget build(BuildContext context) {
    final String displayImage = imgPath?.isNotEmpty == true
        ? imgPath!
        : ATImgStrings.weCanDoHardThingsBgImage;

    final bool isNetworkImage = displayImage.startsWith('http');

    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topRight,
      height: 360,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: isNetworkImage
                    ? CachedNetworkImageProvider(displayImage)
                    : AssetImage(displayImage) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: ATContainer(
              height: 32,
              width: 32,
              boxShape: BoxShape.circle,
              color: ATColors.hex0D0D0D.withValues(alpha: 0.7),
              child: const Icon(Icons.more_horiz),
            ),
          ),
        ],
      ),
    );
  }
}

class CoverPicWithTopRightMoreIcon extends StatelessWidget {
  const CoverPicWithTopRightMoreIcon({
    super.key,
    required this.imgPath,
    required this.onMoreTapped,
    this.padding,
  });

  final String imgPath;
  final VoidCallback onMoreTapped;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(10),
      alignment: Alignment.topRight,
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imgPath),
          fit: BoxFit.cover,
        ),
      ),
      child: ATContainer(
        onTap: onMoreTapped,
        height: 32,
        width: 32,
        boxShape: BoxShape.circle,
        color: ATColors.hex0D0D0D.withValues(alpha: 0.7),
        child: const Icon(Icons.more_horiz),
      ),
    );
  }
}
