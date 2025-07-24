import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';

class ATHashtagBadge extends StatelessWidget {
  const ATHashtagBadge({
    super.key,
    this.badgeSize = 40,
    this.hashSize = 25
  });

  final double badgeSize, hashSize;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      alignment: Alignment.center,
      height: badgeSize, width: badgeSize,
      boxShape: BoxShape.circle,
      color: ATColors.white,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          ATColors.black,
          BlendMode.srcATop
        ),
        child: ATImgLoader(
          imgPath: ATImgStrings.HASH_ICON,
          height: hashSize, width: hashSize,
        ),
      ),
    );
  }
}