import 'package:amptive/src/config/config_export.dart';
import 'package:flutter/material.dart';
import '../../../../shared/image_loader_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RenderCommunityName extends StatelessWidget {
  const RenderCommunityName({super.key, this.communityName});

  final String? communityName;

  @override
  Widget build(BuildContext context) {
    final Color metadataColor = Colors.white.withValues(alpha: 0.6);
    return Row(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          ATImgStrings.groupIcon,
          height: 25,
          width: 25,
          colorFilter: ColorFilter.mode(
            metadataColor,
            BlendMode.srcIn,
          ),
        ),
        Text(
          (communityName ?? ATStrings.society).toUpperCase(),
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            height: 1,
            color: metadataColor,
          ),
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
    final Color metadataColor = Colors.white.withValues(alpha: 0.6);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Transform.translate(
          offset: const Offset(0, -0.5),
          child: SvgPicture.asset(
            ATImgStrings.detailCalendarFilledIcon,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              metadataColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        Flexible(
          child: Text(
            text1.toUpperCase(),
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1,
              color: metadataColor,
            ),
          ),
        ),
      ],
    );
  }
}
