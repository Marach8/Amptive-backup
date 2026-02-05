import 'package:flutter/material.dart';
import '../../../../../config/utils/colors.dart';
import '../../../../../config/utils/font_sizes.dart';
import '../../../common_widgets/circle_avatar.dart';
import '../../../../../shared/custom_container_widget.dart';
import '../../../common_widgets/image_loader_widget.dart';


class AmptivePaidShowModel extends StatelessWidget {
  const AmptivePaidShowModel({
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
            children: <Widget>[
              ATContainer(
                height: 12, width: 12,
                color: ATColors.hexB6B6B6,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "P",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: ATColors.hex0D0D0D
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  'glendonnoyle',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATSizes.size13,
                    color: ATColors.hexA8A8A8,
                  ),
                ),
              ),
              const SizedBox(width: 5),

              Align(
                alignment: Alignment.bottomCenter,
                child: ATCircleAvatar(
                  diameter: 4,
                  color: ATColors.hexA8A8A8,
                ),
              ),
              Text(
                'LIVE',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ATColors.hexA8A8A8,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}