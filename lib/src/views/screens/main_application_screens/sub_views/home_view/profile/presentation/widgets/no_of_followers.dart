import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/go_live/follow_or_subscribe_dialog.dart';
import 'package:amptive/src/utils/dialogs/profile/show_top_creator_societies.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class NoOfFollowers extends StatelessWidget {
  const NoOfFollowers({
    super.key,
    required this.noOfFollowers
  });

  final String noOfFollowers;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(ATRoutes.PROFILE_FOLLOWING_SCREEN),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: const Size(16, 16),
            painter: RoundedScallopedPainter(
              color: ATColors.dimWhiteColor1
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(Icons.star, color: ATColors.black, size: 12),
            ),
          ),
          Text(
            noOfFollowers,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: ATFontSizes.size16
            ),
          ),
          const SizedBox(width: 5),
          Text(
            ATStrings.FOLLOWERS,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: ATFontSizes.size16
            ),
          ),
        ],
      ),
    );
  }
}
