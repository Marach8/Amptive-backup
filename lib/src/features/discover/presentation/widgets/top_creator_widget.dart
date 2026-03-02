import 'package:flutter/material.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../shared/image_loader_widget.dart';

class TopCreatorWidget extends StatelessWidget {
  const TopCreatorWidget({
    super.key,
    required this.picture
  });
  final String picture;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        children: <Widget>[
          ATImgLoader(imgPath: picture),
          const SizedBox(height: 5),
          Text(
            'ammybach',
            style: Theme.of(context).textTheme.titleMedium
          ),
        ],
      ),
    );
  }
}