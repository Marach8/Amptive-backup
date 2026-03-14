import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/image_strings.dart';
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
    this.episode,
  });
  final Episode? episode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
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
            episode?.title ?? '',
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
