import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/image_loader_widget.dart';
import '../../../../shared/live_indicators.dart';

/// Grid-cell twin of the discover card ([RenderTrendingHashTag]): same
/// square artwork, corner rounding, LIVE badge and text styling — just
/// proportionally scaled up to fill a two-column grid cell.
class TrendingSocietyHashtagWidget extends StatelessWidget {
  const TrendingSocietyHashtagWidget({
    super.key,
    required this.trendingPicture,
    this.title = '',
    this.creatorName = '',
    this.creatorAvatar = ATImgStrings.noAvatarImage,
    this.statusLabel = 'LIVE',
    this.isPaid = false,
    this.onTap,
  });

  final String trendingPicture, title, creatorName, creatorAvatar, statusLabel;
  final bool isPaid;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isLive = statusLabel.toUpperCase() == 'LIVE';

    return Semantics(
      button: onTap != null,
      label: '$title by $creatorName, $statusLabel',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: ClipSmoothRect(
                radius:
                    SmoothBorderRadius(cornerRadius: 5, cornerSmoothing: 0.8),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // Explicit size matters: the loader decodes images at
                    // its width param (default 35!) — without this the
                    // cover is decoded tiny and upscaled into pixelation.
                    LayoutBuilder(builder: (_, BoxConstraints constraints) {
                      return ATImgLoader(
                        imgPath: trendingPicture,
                        boxFit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      );
                    }),
                    if (isLive)
                      const Positioned(
                        top: 8,
                        left: 8,
                        child: LiveIndicatorWithAnimatingDot(compact: true),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
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
    );
  }
}
