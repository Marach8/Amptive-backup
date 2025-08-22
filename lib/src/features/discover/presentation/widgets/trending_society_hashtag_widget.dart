import 'package:amptive/src/features/discover/presentation/widgets/render_trending_hashtag.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../views/widgets/common_widgets/circle_avatar.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';

class TrendingSocietyHashtagWidget extends StatelessWidget {
  const TrendingSocietyHashtagWidget({
    super.key,
    required this.trendingPicture
  });

  final String trendingPicture;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ATContainer(
          radius: 5, clipBehavior: Clip.hardEdge,
          height: 160, width: context.screenWidth,
          child: ATImgLoader(
            imgPath: trendingPicture,
            boxFit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 12,),
        LayoutBuilder(
          builder: (_, BoxConstraints kst) {
            return SizedBox(
              width: kst.maxWidth,
              child: Text(
                "Former CIA Agent on The Name",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const PaidIcon(),
            const SizedBox(width: 5),
            Flexible(
              child: SizedBox(
                child: Text(
                  'glendonnoyle',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATFontSizes.size13,
                    color: ATColors.hexA8A8A8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5,),

            Align(
              alignment: Alignment.bottomCenter,
              child: ATCircleAvatar(
                diameter: 4,
                color: ATColors.hexA8A8A8,
              ),
            ),
            const SizedBox(width: 5,),
            Text(
              'LIVE',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: ATColors.hexA8A8A8,
              ),
            ),
          ],
        )
      ],
    );
  }
}