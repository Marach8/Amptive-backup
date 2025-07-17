import 'package:amptive/src/features/discover/presentation/widgets/render_trending_hashtag.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../views/widgets/common_widgets/circle_avatar.dart';
import '../../../../views/widgets/common_widgets/custom_container_widget.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';

class TrendingTechnologyWidget extends StatelessWidget {
  const TrendingTechnologyWidget({
    super.key,
    required this.trendingPicture
  });
  final String trendingPicture;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      width: 250,
      padding: const EdgeInsets.only(left: 10),
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
              ),
            ),
          ),
          const SizedBox(height: 12,),
          LayoutBuilder(
            builder: (_, BoxConstraints kst) {
              return SizedBox(
                width: kst.maxWidth,
                child: Text(
                  "Don't forget who you are",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
          ),
          Row(
            children: <Widget>[
              const PaidIcon(),
              const SizedBox(width: 5,),
              Flexible(
                child: Text(
                  'glendonnor',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATFontSizes.size13,
                    color: ATColors.hexCDCDCD
                  ),
                ),
              ),
              const SizedBox(width: 5,),
              ATCircleAvatar(
                diameter: 4,
                color: ATColors.hexCDCDCD
              ),
              const SizedBox(width: 5,),
              Text(
                'FRIDAY',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ATColors.hexCDCDCD
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}