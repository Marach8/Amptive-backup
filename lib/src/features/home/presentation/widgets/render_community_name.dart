import 'package:amptive/src/config/config_export.dart';
import 'package:flutter/material.dart';
import '../../../../shared/image_loader_widget.dart';

class RenderCommunityName extends StatelessWidget {
  const RenderCommunityName({super.key, this.communityName});

  final String? communityName;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: <Widget>[
         const ATImgLoader(
          imgPath: ATImgStrings.groupIcon,
          height: 24,
          width: 24,
        ),
        Text(
          (communityName ?? ATStrings.society).toUpperCase(),
          style: context.textTheme.bodyMedium
              ?.copyWith(color: ATColors.hexA8A8A8, fontSize: ATSizes.size14),
        ),
      ],
    );
  }
}



class EpisodeScheduleDateIndicator extends StatelessWidget {
  const EpisodeScheduleDateIndicator(
      {super.key, this.text1 = '27 Sep, 2025 at 18:00'});

  final String text1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: <Widget>[
        const ATImgLoader(
          imgPath: ATImgStrings.filledCalenderIcon,
          height: 20,
          width: 20,
          boxFit: BoxFit.scaleDown,
        ),
        Flexible(
          child: Text(
            text1,
            style: context.textTheme.bodyMedium
                ?.copyWith(color: ATColors.hexA8A8A8, fontSize: ATSizes.size14),
          ),
        ),
      ],
    );
  }
}
