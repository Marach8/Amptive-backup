import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/calender/calender_export.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            color: ATColors.dimWhiteColor1,
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: ATColors.dimWhiteColor1,
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
    this.episodeCount = 1,
  });
  final Episode? activeEpisode;
  final VoidCallback? onTappOverride;
  final int episodeCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTappOverride ?? ()async{
        final Episode? editedEpisode = await context.pushNamed(
          ATRoutes.previewEpisodeScreen,
          extra: activeEpisode ?? const Episode(),
        ) as Episode?;

        if(context.mounted && editedEpisode != null 
          && editedEpisode != activeEpisode){
            context.read<ShowDetailCubit>().updateAnEpisode(editedEpisode);
          }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: <Widget>[
          SvgPicture.string(
            '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="0.00012207" width="19.23" height="19.23" rx="9.615" fill="#FF6482"/>
<path d="M6.2207 14.4883C5.95752 14.4883 5.73214 14.3947 5.54456 14.2074C5.3573 14.0198 5.26367 13.7944 5.26367 13.5312V6.83203C5.26367 6.56885 5.3573 6.34363 5.54456 6.15637C5.73214 5.96879 5.95752 5.875 6.2207 5.875H6.69922V5.38452C6.69922 5.24894 6.745 5.13729 6.83655 5.04956C6.92843 4.96183 7.04215 4.91797 7.17773 4.91797C7.31331 4.91797 7.42704 4.96375 7.51892 5.0553C7.61047 5.14718 7.65625 5.2609 7.65625 5.39648V5.875H11.4844V5.38452C11.4844 5.24894 11.5303 5.13729 11.6222 5.04956C11.7137 4.96183 11.8273 4.91797 11.9629 4.91797C12.0985 4.91797 12.212 4.96375 12.3036 5.0553C12.3955 5.14718 12.4414 5.2609 12.4414 5.39648V5.875H12.9199C13.1831 5.875 13.4085 5.96879 13.5961 6.15637C13.7833 6.34363 13.877 6.56885 13.877 6.83203V13.5312C13.877 13.7944 13.7833 14.0198 13.5961 14.2074C13.4085 14.3947 13.1831 14.4883 12.9199 14.4883H6.2207ZM6.2207 13.5312H12.9199V8.74609H6.2207V13.5312Z" fill="white" fill-opacity="0.8"/>
</svg>''',
            width: 20,
            height: 20,
          ),
          Text(
            '$episodeCount Episode${episodeCount == 1 ? '' : 's'}',
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: ATSizes.size15,
              fontWeight: ATFontWeights.w600,
              color: ATColors.dimWhiteColor1
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: ATColors.dimWhiteColor1,
          )
        ],
      ),
    );
  }
}
