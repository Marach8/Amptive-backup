import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/episodes/presentation/widgets/existing_episodes_indicator.dart';
import 'package:amptive/src/features/home/presentation/widgets/event_or_show_card.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/opacity_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_actions_modal.dart';
import 'package:intl/intl.dart';

class DetailedScreenHeader extends StatelessWidget {
  const DetailedScreenHeader({
    super.key,
    required this.homeFeedItem,
    required this.displayImage,
    this.onMoreTapped,
    this.onShowNameTapped,
  });

  final HomeFeedItem? homeFeedItem;
  final String? displayImage;

  /// Overrides what the "..." button opens (e.g. owner actions).
  final Future<void> Function()? onMoreTapped;
  final VoidCallback? onShowNameTapped;

  @override
  Widget build(BuildContext context) {
    // Determine the indicator logic dynamically globally
    final bool isEpisode = homeFeedItem?.contentType == 'episode';
    final String fallbackTitle = isEpisode
        ? 'Live Show'
        : (homeFeedItem?.contentType == 'standalone'
            ? 'Live Event'
            : 'Scheduled');

    final Widget? leadingIcon =
        isEpisode ? SvgPicture.string(ATImgStrings.episodeIconSvg) : null;

    final String imgPath =
        isEpisode ? ATImgStrings.showIcon : ATImgStrings.calenderIcon;

    final bool hasStarted =
        (homeFeedItem?.startedAt?.trim().isNotEmpty ?? false) ||
            (homeFeedItem?.livestreamId?.trim().isNotEmpty ?? false);
    final bool isLive =
        homeFeedItem?.status?.toLowerCase() == 'live' && hasStarted;
    final Color metadataColor = Colors.white.withValues(alpha: 0.6);
    final TextStyle? metadataTextStyle =
        context.textTheme.bodySmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      height: 1,
      color: metadataColor,
    );
    const double iconLabelGap = 6;
    final String communityName =
        homeFeedItem?.communityName?.trim().isNotEmpty ?? false
            ? homeFeedItem!.communityName!.trim()
            : ATStrings.society;
    String? formattedDate;
    final String? scheduledFor = homeFeedItem?.scheduledFor;
    if (!isLive && scheduledFor != null && scheduledFor.trim().isNotEmpty) {
      try {
        final DateTime dateTime = DateTime.parse(scheduledFor).toLocal();
        formattedDate = DateFormat('E, d MMM • h:mm a').format(dateTime);
      } catch (_) {
        formattedDate = scheduledFor;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ATEventOrShowCard(
          imgPath: displayImage,
          showMoreIcon: true,
          padding: EdgeInsets.zero,
          onMoreTapped: () async {
            if (onMoreTapped != null) {
              await onMoreTapped!();
              return;
            }
            try {
              await showProgramOptions(
                context: context,
                toggleFollowingCubit: ToggleFollowingCubit(
                  initialStatus: const FollowingStatus(isFollowing: false, followerCount: 0)
                ),
                targetUserName: homeFeedItem?.hostName ?? '',
                targetUserId: homeFeedItem?.hostId ?? '',
                targetUserProfileUrl: homeFeedItem?.hostProfileImageUrl,
                programType: homeFeedItem?.contentType?.toLowerCase(),
                contentId: homeFeedItem?.id,
                programTitle: homeFeedItem?.title,
                coverUrl: homeFeedItem?.coverUrl,
              );
            } catch (e) {
              debugPrint('Error showing program options: \$e');
            }
          },
        ),
        const SizedBox(height: 24),
        if (homeFeedItem?.contentType != 'standalone') ...<Widget>[
          InkWell(
            onTap: isEpisode ? onShowNameTapped : null,
            borderRadius: BorderRadius.circular(8),
            child: ShowOrEventIndicatorWithTitle(
              title: homeFeedItem?.showTitle ?? fallbackTitle,
              leading: leadingIcon,
              eventOrShowImgPath:
                  leadingIcon == null ? imgPath : ATImgStrings.showIcon,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          maxLines: 2,
          homeFeedItem?.title ?? '',
          overflow: TextOverflow.clip,
          style: context.textTheme.displayMedium?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            height: 34 / 26,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isLive) ...<Widget>[
              ATAnimOpacity(
                minOpacity: 0.6,
                child: SvgPicture.asset(
                  ATImgStrings.wifiIcon,
                  height: 25,
                  width: 25,
                  colorFilter: ColorFilter.mode(
                    metadataColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'LIVE',
                style: metadataTextStyle,
              ),
            ] else if (formattedDate != null) ...<Widget>[
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
              const SizedBox(width: iconLabelGap),
              Text(
                formattedDate.toUpperCase(),
                style: metadataTextStyle,
              ),
            ],
            if (isLive || formattedDate != null) const SizedBox(width: 16),
            SvgPicture.asset(
              ATImgStrings.groupIcon,
              height: 25,
              width: 25,
              colorFilter: ColorFilter.mode(
                metadataColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: iconLabelGap),
            Text(
              communityName.toUpperCase(),
              style: metadataTextStyle,
            ),
          ],
        ),
      ],
    );
  }
}
