import 'package:flutter/material.dart';
import '../../../common_widgets/image_loader_widget.dart';

class AmptiveMore2DiscoverModel extends StatelessWidget {
  final String picture;
  const AmptiveMore2DiscoverModel({
    super.key,
    required this.picture
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(5),
        child: AmptiveImageLoaderWidget(imagePath: picture),
      ),
    );
  }
}