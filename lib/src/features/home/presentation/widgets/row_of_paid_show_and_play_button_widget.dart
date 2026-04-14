import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';

import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/extensions/context_extensions.dart';

class PaidShowAndPlayBtnWidget extends StatelessWidget {
  const PaidShowAndPlayBtnWidget({
    super.key,
    this.icon,
    this.homeFeedItem,
  });
  final IconData? icon;
  final HomeFeedItem? homeFeedItem;

  bool get _isLive => homeFeedItem?.status?.toLowerCase() == 'live';

  bool get _canGoToDetail {
    if (homeFeedItem == null) return false;
    if (_isLive && homeFeedItem?.livestreamId != null) return true;
    return true;
  }

  String get _showTypeLabel {
    final String? type = homeFeedItem?.showType?.toLowerCase();
    if (type == 'paid') return 'PAID SHOW';
    if (type == 'free') return 'FREE SHOW';
    if (type == 'premium') return 'PREMIUM';
    return '';
  }

  void _onPlayTapped(BuildContext context) {
    if (homeFeedItem == null) return;

    final String contentType = homeFeedItem!.contentType ?? '';
    final bool isStandalone = contentType == 'standalone';

    if (_isLive) {
      if (isStandalone) {
        context.pushNamed(
          ATRoutes.LIVE_EVENT_DETAILED,
          extra: homeFeedItem,
        );
      } else {
        context.pushNamed(
          ATRoutes.LIVE_SHOW_DETAILED,
          extra: homeFeedItem,
        );
      }
    } else {
      context.pushNamed(
        ATRoutes.SCHEDULE_DETAILED,
        extra: homeFeedItem,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String label = _showTypeLabel;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Container(
              padding: const EdgeInsets.all(8.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ATColors.hex0D0D0D),
              child: Text(label,
                  style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: ATFontWeights.w500,
                      fontSize: ATSizes.size10)),
            ),
          ),
        SizedBox(
          height: 45,
          width: 45,
          child: GestureDetector(
            onTap: _canGoToDetail ? () => _onPlayTapped(context) : null,
            child: CircleAvatar(
              backgroundColor: ATColors.hexB6B6B6,
              child: Icon(icon ?? Icons.play_arrow,
                  color: ATColors.hex0D0D0D, size: 30),
            ),
          ),
        )
      ],
    );
  }
}
