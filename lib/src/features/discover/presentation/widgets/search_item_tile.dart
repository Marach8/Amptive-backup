import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/image_loader_widget.dart';

class SearchItemTile extends StatelessWidget {
  const SearchItemTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leadingImagePath,
    this.isCircular = false,
    this.isPaid = false,
    this.statusText,
    this.onTap,
    this.onRemove,
    this.trailing,
  });
  final String title, leadingImagePath;
  final String? subtitle;

  /// e.g. 'LIVE', 'Ended', '27 SEP 2024 at 19:00' — rendered after a dot.
  final String? statusText;
  final bool isCircular, isPaid;
  final VoidCallback? onTap, onRemove;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    const double size = 50;
    final TextStyle? subtitleStyle =
        Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ATColors.hexC2C2C2,
            fontWeight: ATFontWeights.w500,
            fontSize: ATSizes.size13);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.white.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(isCircular ? size * 0.6 : 5),
              child: ATImgLoader(
                // People without an uploaded photo get the default avatar.
                imgPath: isCircular && leadingImagePath.isEmpty
                    ? ATImgStrings.noAvatarImage
                    : leadingImagePath,
                height: size,
                width: size,
                boxFit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: ATSizes.size15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      if (isPaid) ...<Widget>[
                        Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ATColors.hexB6B6B6,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'P',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          subtitle ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: subtitleStyle,
                        ),
                      ),
                      if (statusText != null &&
                          statusText!.isNotEmpty) ...<Widget>[
                        const SizedBox(width: 5),
                        Text('•', style: subtitleStyle),
                        const SizedBox(width: 5),
                        // Never truncate the date/status — the label before
                        // it shrinks instead.
                        Text(
                          statusText!,
                          maxLines: 1,
                          style: subtitleStyle,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            trailing ??
                InkWell(
                  onTap: onRemove ?? () {},
                  splashColor: ATColors.hex303030,
                  borderRadius: BorderRadius.circular(30),
                  child: const SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: ATImgLoader(
                        imgPath: ATImgStrings.recentRemoveXIcon,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class HashTagSearchItemTile extends StatelessWidget {
  const HashTagSearchItemTile({
    super.key,
    required this.title,
    this.onTap,
    this.onRemove,
    this.trailing,
  });

  final String title;
  final VoidCallback? onTap, onRemove;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.white.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: <Widget>[
            const ATImgLoader(
              imgPath: ATImgStrings.hashtagCircleIcon,
              height: 50,
              width: 50,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${ATStrings.HASH}$title',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: ATSizes.size15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    // Capitalized label — only usernames are lowercase.
                    ATStrings.hashtags,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ATColors.hexC2C2C2,
                        fontWeight: ATFontWeights.w500,
                        fontSize: ATSizes.size13),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            trailing ??
                InkWell(
                  onTap: onRemove ?? () {},
                  splashColor: ATColors.hex303030,
                  borderRadius: BorderRadius.circular(30),
                  child: const SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: ATImgLoader(
                        imgPath: ATImgStrings.recentRemoveXIcon,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
