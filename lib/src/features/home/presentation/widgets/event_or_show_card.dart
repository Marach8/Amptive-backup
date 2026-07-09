import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/custom_container_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ATEventOrShowCard extends StatelessWidget {
  const ATEventOrShowCard({
    super.key,
    this.imgPath,
    this.showMoreIcon = true,
    this.padding,
    this.onMoreTapped,
  });

  final String? imgPath;
  final bool showMoreIcon;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onMoreTapped;

  @override
  Widget build(BuildContext context) {
    final String displayImage = imgPath?.isNotEmpty == true
        ? imgPath!
        : ATImgStrings.weCanDoHardThingsBgImage;

    final bool isNetworkImage = displayImage.startsWith('http');

    return Container(
      padding: padding ?? const EdgeInsets.all(10),
      alignment: Alignment.topRight,
      height: 360,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 16,
                  cornerSmoothing: 1,
                ),
              ),
              image: DecorationImage(
                image: isNetworkImage
                    ? CachedNetworkImageProvider(displayImage)
                    : AssetImage(displayImage) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (showMoreIcon)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onMoreTapped,
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.string(
                  '''<svg width="33" height="33" viewBox="0 0 33 33" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle cx="16.0219" cy="16.0219" r="16.0219" fill="black" fill-opacity="0.7"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M8.33136 17.9453C9.38881 17.9453 10.254 17.0801 10.254 16.0227C10.254 14.9652 9.38881 14.1001 8.33136 14.1001C7.27392 14.1001 6.40873 14.9652 6.40873 16.0227C6.40873 17.0801 7.27392 17.9453 8.33136 17.9453ZM16.0219 17.9453C17.0793 17.9453 17.9445 17.0801 17.9445 16.0227C17.9445 14.9652 17.0793 14.1001 16.0219 14.1001C14.9644 14.1001 14.0992 14.9652 14.0992 16.0227C14.0992 17.0801 14.9644 17.9453 16.0219 17.9453ZM23.7124 17.9453C24.7698 17.9453 25.635 17.0801 25.635 16.0227C25.635 14.9652 24.7698 14.1001 23.7124 14.1001C22.6549 14.1001 21.7898 14.9652 21.7898 16.0227C21.7898 17.0801 22.6549 17.9453 23.7124 17.9453Z" fill="white"/>
</svg>''',
                  width: 32,
                  height: 32,
                ),
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
    this.showMoreIcon = true,
  });

  final String imgPath;
  final VoidCallback onMoreTapped;
  final EdgeInsetsGeometry? padding;
  final bool showMoreIcon;

  @override
  Widget build(BuildContext context) {
    final String displayImage = imgPath.isNotEmpty == true
        ? imgPath
        : ATImgStrings.weCanDoHardThingsBgImage;

    final bool isNetworkImage = displayImage.startsWith('http');

    return Container(
      padding: padding ?? const EdgeInsets.all(10),
      alignment: Alignment.topRight,
      height: 360,
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 16,
            cornerSmoothing: 1,
          ),
        ),
        image: DecorationImage(
          image: isNetworkImage
              ? CachedNetworkImageProvider(displayImage)
              : AssetImage(displayImage) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: showMoreIcon
          ? GestureDetector(
              onTap: onMoreTapped,
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.string(
                '''<svg width="33" height="33" viewBox="0 0 33 33" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle cx="16.0219" cy="16.0219" r="16.0219" fill="black" fill-opacity="0.7"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M8.33136 17.9453C9.38881 17.9453 10.254 17.0801 10.254 16.0227C10.254 14.9652 9.38881 14.1001 8.33136 14.1001C7.27392 14.1001 6.40873 14.9652 6.40873 16.0227C6.40873 17.0801 7.27392 17.9453 8.33136 17.9453ZM16.0219 17.9453C17.0793 17.9453 17.9445 17.0801 17.9445 16.0227C17.9445 14.9652 17.0793 14.1001 16.0219 14.1001C14.9644 14.1001 14.0992 14.9652 14.0992 16.0227C14.0992 17.0801 14.9644 17.9453 16.0219 17.9453ZM23.7124 17.9453C24.7698 17.9453 25.635 17.0801 25.635 16.0227C25.635 14.9652 24.7698 14.1001 23.7124 14.1001C22.6549 14.1001 21.7898 14.9652 21.7898 16.0227C21.7898 17.0801 22.6549 17.9453 23.7124 17.9453Z" fill="white"/>
</svg>''',
                width: 32,
                height: 32,
              ),
            )
          : null,
    );
  }
}
