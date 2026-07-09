import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/live_indicators.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PreferredCommunityTrendRow extends StatelessWidget {
  const PreferredCommunityTrendRow({
    super.key,
    required this.item,
    required this.onTap,
    required this.onMoreTap,
  });

  final HomeFeedItem item;
  final VoidCallback onTap, onMoreTap;

  String get _artwork => item.thumbnailUrl?.trim().isNotEmpty == true
      ? item.thumbnailUrl!
      : item.showCoverUrl?.trim().isNotEmpty == true
          ? item.showCoverUrl!
          : item.coverUrl?.trim().isNotEmpty == true
              ? item.coverUrl!
              : ATImgStrings.COMMUNITY_CARD;

  String get _dateLabel {
    final DateTime? date = DateTime.tryParse(
      item.scheduledFor ?? item.startedAt ?? '',
    );
    if (date == null) return 'Date TBA';
    return DateFormat.MMMd().format(date).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLive = item.status?.toLowerCase() == 'live';
    final String creator = item.hostName?.trim().isNotEmpty == true
        ? item.hostName!
        : 'Amptive creator';
    final String activity = isLive
        ? '${NumberFormat.compact().format(item.viewerCount ?? 0)} listening'
        : _dateLabel;

    return Semantics(
      button: true,
      label: '${item.title ?? 'Program'} by $creator, $activity',
      child: InkWell(
        onTap: onTap,
        // Row options live behind a long-press (Apple Music-style) so the
        // list isn't littered with per-row ellipsis buttons.
        onLongPress: () {
          HapticFeedback.mediumImpact();
          onMoreTap();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.white.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 96,
                height: 96,
                child: ClipSmoothRect(
                  radius: SmoothBorderRadius(
                    cornerRadius: 6,
                    cornerSmoothing: 0.8,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ATImgLoader(
                        imgPath: _artwork,
                        width: 96,
                        height: 96,
                        boxFit: BoxFit.cover,
                      ),
                      if (isLive)
                        const Positioned(
                          top: 7,
                          left: 7,
                          child: LiveIndicatorWithAnimatingDot(compact: true),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title ?? 'Untitled program',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 1.18,
                            ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: <Widget>[
                          ClipOval(
                            child: ATImgLoader(
                              imgPath: item.hostProfileImageUrl?.trim()
                                          .isNotEmpty ==
                                      true
                                  ? item.hostProfileImageUrl!
                                  : ATImgStrings.noAvatarImage,
                              width: 18,
                              height: 18,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              creator,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontSize: 13,
                                    color: ATColors.hexA8A8A8,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            '·',
                            style: TextStyle(color: ATColors.hexA8A8A8),
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              activity,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontSize: 13,
                                    color: ATColors.hexA8A8A8,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Scaled-down, dimmed so it reads as tertiary and doesn't
              // compete with the section header's menu button.
              Opacity(
                opacity: 0.55,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: onMoreTap,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: SvgPicture.asset(
                      ATImgStrings.moreHorizontalFilledIcon,
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
