import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../common_widgets/custom_container_widget.dart';
import '../../../../common_widgets/image_loader_widget.dart';

class AmptiveTopCreatorsModel extends StatelessWidget {
  const AmptiveTopCreatorsModel({
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