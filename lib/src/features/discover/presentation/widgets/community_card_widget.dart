import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';
import '../../../../shared/image_loader_widget.dart';

class CommunityCardWidget extends StatelessWidget {
  const CommunityCardWidget({
    super.key,
    required this.picture,
    this.padding,
    this.onTap,
  });
  final String picture;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      margin: padding ?? const EdgeInsets.only(left: 10),
      clipBehavior: Clip.hardEdge,
      radius: 5,
      onTap: onTap,
      child: ATImgLoader(imgPath: picture),
    );
  }
}
