import 'package:flutter/material.dart';
import '../../../../../config/utils/colors.dart';
import '../../../../../config/utils/font_sizes.dart';
import '../../../../../shared/circle_avatar.dart';
import '../../../../../shared/custom_container_widget.dart';
import '../../../../../shared/image_loader_widget.dart';


class AmptiveFreeShowModel extends StatelessWidget {
  const AmptiveFreeShowModel({
    super.key,
    required this.trendingPicture
  });
  final String trendingPicture;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      width: 137,
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(5),
            child: ATImgLoader(imgPath: trendingPicture),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 135,
            child: Text(
              "Don't forget who you are",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[              
              Expanded(
                child: Text(
                  'figma',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATSizes.size13,
                    color: ATColors.hexA8A8A8
                  ),
                ),
              ),
              const SizedBox(width: 2),

              Align(
                alignment: Alignment.bottomCenter,
                child: ATCircleAvatar(
                  diameter: 4,
                  color: ATColors.hexA8A8A8
                ),
              ),
              const SizedBox(width: 2),
              Text(
                'LIVE',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ATColors.hexA8A8A8
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}