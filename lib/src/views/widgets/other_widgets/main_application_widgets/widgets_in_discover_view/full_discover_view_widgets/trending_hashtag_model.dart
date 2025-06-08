import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../common_widgets/circle_avatar.dart';
import '../../../../common_widgets/custom_container_widget.dart';
import '../../../../common_widgets/image_loader_widget.dart';

class AmptiveTrendingHashtagModel extends StatelessWidget {
  final String trendingPicture;
  const AmptiveTrendingHashtagModel({
    super.key,
    required this.trendingPicture
  });

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      width: 137,
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(5),
            child: ATImgLoader(imgPath: trendingPicture),
          ),
          const Gap(5),
          SizedBox(
            width: 135,
            child: Text(
              "Don't forget who you are",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ATContainer(
                height: 12, width: 12,
                color: ATColors.authHintColor,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "P",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: ATColors.brandBlack
                    ),
                  ),
                ),
              ),
              const Gap(2),
              Flexible(
                child: Text(
                  'glendonnoyle',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATFontSizes.size13,
                    color: ATColors.hexA8A8A8,
                  ),
                ),
              ),
              const Gap(5),
              
              Align(
                alignment: Alignment.bottomCenter,
                child: ATCircleAvatar(
                  diameter: 4,
                  color: ATColors.hexA8A8A8,
                ),
              ),
              const Gap(5),
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