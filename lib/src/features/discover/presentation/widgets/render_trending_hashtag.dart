import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../shared/image_loader_widget.dart';
import '../../../../shared/live_indicators.dart';

class RenderTrendingHashTag extends StatelessWidget {
  const RenderTrendingHashTag({
    super.key,
    required this.trendingPicture,
    this.title,
    this.creatorName = 'glendonnoyle',
    this.creatorAvatar = ATImgStrings.noAvatarImage,
    this.statusLabel = 'LIVE',
    this.isPaid = true,
    this.onTap,
    this.trailingSpacing = 16,
    this.squareArtwork = false,
  });

  final String trendingPicture;
  final String? title;
  final String creatorName, creatorAvatar, statusLabel;
  final bool isPaid;
  final bool squareArtwork;
  final VoidCallback? onTap;
  final double trailingSpacing;

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 145;
    final String cardTitle = title ?? "Don't forget who you are";

    return Padding(
      padding: EdgeInsets.only(right: trailingSpacing),
      child: Semantics(
        button: onTap != null,
        label: '$cardTitle by $creatorName, $statusLabel',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (squareArtwork)
                  SizedBox(
                    width: cardWidth,
                    height: cardWidth,
                    child: _Artwork(
                      image: trendingPicture,
                      statusLabel: statusLabel,
                      width: cardWidth,
                      height: cardWidth,
                    ),
                  )
                else
                  Expanded(
                    child: _Artwork(
                      image: trendingPicture,
                      statusLabel: statusLabel,
                      width: cardWidth,
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: cardWidth,
                  child: Text(
                    cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Row(
                  children: <Widget>[
                    ClipOval(
                      child: ATImgLoader(
                        imgPath: creatorAvatar,
                        height: 14,
                        width: 14,
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
                    if (statusLabel.toUpperCase() == 'LIVE') ...<Widget>[
                      Icon(
                        Icons.confirmation_number,
                        size: 12,
                        color: ATColors.hexA8A8A8,
                      ),
                      const SizedBox(width: 3),
                    ],
                    Text(
                      statusLabel.toUpperCase() == 'LIVE'
                          ? (isPaid ? 'Paid' : 'Free')
                          : statusLabel,
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
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({
    required this.image,
    required this.statusLabel,
    required this.width,
    this.height,
  });

  final String image, statusLabel;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(cornerRadius: 5, cornerSmoothing: 0.8),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ATImgLoader(
            imgPath: image,
            boxFit: BoxFit.cover,
            alignment: Alignment.topCenter,
            width: width,
            height: height,
          ),
          if (statusLabel.toUpperCase() == 'LIVE')
            const Positioned(
              top: 8,
              left: 8,
              child: LiveIndicatorWithAnimatingDot(compact: true),
            ),
        ],
      ),
    );
  }
}

class PaidIcon extends StatelessWidget {
  const PaidIcon({super.key, this.size});
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      height: size ?? 12,
      width: size ?? 12,
      color: ATColors.hexB6B6B6,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          "P",
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: ATColors.hex0D0D0D, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
