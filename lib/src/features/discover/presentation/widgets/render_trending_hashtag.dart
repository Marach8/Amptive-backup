import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/font_sizes.dart';
import '../../../../views/widgets/common_widgets/circle_avatar.dart';
import '../../../../views/widgets/common_widgets/custom_container_widget.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';

class RenderTrendingHashTag extends StatelessWidget {
  const RenderTrendingHashTag({
    super.key,
    required this.trendingPicture
  });

  final String trendingPicture;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      width: 145,
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(5),
              child: ATImgLoader(
                imgPath: trendingPicture,
                boxFit: BoxFit.fill,
                width: 145
              ),
            ),
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: 145,
            child: Text(
              "Don't forget who you are",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ATContainer(
                height: 12, width: 12,
                color: ATColors.authHintColor,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "P",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: ATColors.hex0D0D0D,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4,),
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