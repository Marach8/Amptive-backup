import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../common_widgets/custom_container_widget.dart';
import '../../../common_widgets/image_loader_widget.dart';

class AmptiveTopCreatorsModel extends StatelessWidget {
  final String picture;
  const AmptiveTopCreatorsModel({
    super.key,
    required this.picture
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveCustomContainer(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        children: [
          AmptiveImageLoaderWidget(imagePath: picture), 
          const Gap(5),
          Text(
            'ammybach',
            style: Theme.of(context).textTheme.titleMedium
          ),
        ],
      ),
    );
  }
}