import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/image_loader_widget.dart';

class ShowOrEventIndicatorWithTitle extends StatelessWidget {
  const ShowOrEventIndicatorWithTitle({
    super.key,
    this.title = 'We Can Do Hard Things',
    this.eventOrShowImgPath = ATImgStrings.showIcon,
    this.leading,
  });

  final String eventOrShowImgPath, title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: <Widget>[
        leading ?? ATImgLoader(imgPath: eventOrShowImgPath),
        Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: ATSizes.size15,
            color: ATColors.dimWhiteColor1
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios_sharp,
          size: 12,
          weight: 20,
        )
      ],
    );
  }
}



class ExistingEpisodesIndicator extends StatelessWidget {
  const ExistingEpisodesIndicator({
    super.key,
    this.activeEpisode,
    this.onTappOverride,
  });
  final Episode? activeEpisode;
  final VoidCallback? onTappOverride;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTappOverride ?? (){
        context.pushNamed(
          ATRoutes.previewEpisodeScreen,
          extra: activeEpisode ?? Episode(),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: <Widget>[
          Container(
            height: 20, width: 20,
            decoration: BoxDecoration(
              color: ATColors.hexFF6482,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(4),
            child: const ATImgLoader(
              imgPath: ATImgStrings.calenderIcon,
            ),
          ),
          Text(
            activeEpisode?.title ?? '',
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: ATSizes.size15,
              color: ATColors.dimWhiteColor1
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_sharp,
            size: 12,
            weight: 20,
          )
        ],
      ),
    );
  }
}
