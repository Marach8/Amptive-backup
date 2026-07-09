import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../shared/image_loader_widget.dart';
import '../../../../shared/live_indicators.dart';

class TrendingTechnologyWidget extends StatelessWidget {
  const TrendingTechnologyWidget({
    super.key,
    required this.trendingPicture,
    required this.title,
    required this.creatorName,
    required this.creatorAvatar,
    required this.statusLabel,
    required this.isPaid,
    required this.onTap,
  });

  final String trendingPicture, title, creatorName, creatorAvatar, statusLabel;
  final bool isPaid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const double artworkSize = 238;
    final bool isLive = statusLabel.toUpperCase() == 'LIVE';

    return Semantics(
      button: true,
      label: '$title by $creatorName, $statusLabel',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ATContainer(
          width: 250,
          padding: const EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: ClipSmoothRect(
                  clipBehavior: Clip.hardEdge,
                  radius: SmoothBorderRadius(
                    cornerRadius: 5,
                    cornerSmoothing: 0.8,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ATImgLoader(
                        imgPath: trendingPicture,
                        width: artworkSize,
                        height: artworkSize,
                        boxFit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                      if (isLive)
                        const Positioned(
                          top: 8,
                          left: 8,
                          child: LiveIndicatorWithAnimatingDot(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(builder: (_, BoxConstraints kst) {
                return SizedBox(
                  width: kst.maxWidth,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }),
              Row(
                children: <Widget>[
                  ClipOval(
                    child: ATImgLoader(
                      imgPath: creatorAvatar,
                      width: 14,
                      height: 14,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      creatorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: ATSizes.size13,
                            color: ATColors.hexA8A8A8,
                          ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '•',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          color: ATColors.hexA8A8A8,
                        ),
                  ),
                  const SizedBox(width: 5),
                  if (isLive) ...<Widget>[
                    Icon(
                      Icons.confirmation_number,
                      size: 12,
                      color: ATColors.hexA8A8A8,
                    ),
                    const SizedBox(width: 3),
                  ],
                  Text(
                    isLive ? (isPaid ? 'Paid' : 'Free') : statusLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: ATSizes.size12,
                          color: ATColors.hexA8A8A8,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
