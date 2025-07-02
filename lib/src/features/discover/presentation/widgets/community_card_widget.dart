import 'package:flutter/material.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';

class CommunityCardWidget extends StatelessWidget {
  const CommunityCardWidget({
    super.key,
    required this.picture,
    this.padding
  });
  final String picture;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 10),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(5),
        child: ATImgLoader(imgPath: picture),
      ),
    );
  }
}