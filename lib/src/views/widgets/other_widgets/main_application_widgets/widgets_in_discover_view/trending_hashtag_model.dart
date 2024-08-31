import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/font_sizes.dart';
import '../../../common_widgets/circle_avatar.dart';
import '../../../common_widgets/custom_container_widget.dart';
import '../../../common_widgets/image_loader_widget.dart';

class AmptiveTrendingHashtagModel extends StatelessWidget {
  final String trendingPicture;
  const AmptiveTrendingHashtagModel({
    super.key,
    required this.trendingPicture
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveCustomContainer(
      width: 137,
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(5),
            child: AmptiveImageLoaderWidget(imagePath: trendingPicture),
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
            children: [
              AmptiveCustomContainer(
                height: 12, width: 12,
                color: AmptiveColors.authHintColor,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "P",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AmptiveColors.brandBlackColor
                    ),
                  ),
                ),
              ),
              const Gap(2),
              Expanded(
                child: Text(
                  'glendonnor',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: AmptiveFontSizes.size13,
                    color: AmptiveColors.authHintColor2
                  ),
                ),
              ),
              
              Align(
                alignment: Alignment.bottomCenter,
                child: AmptiveCirceAvatarWidget(
                  diameter: 5,
                  color: AmptiveColors.authHintColor
                ),
              ),
              Text(
                'LIVE',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AmptiveColors.authHintColor2
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}