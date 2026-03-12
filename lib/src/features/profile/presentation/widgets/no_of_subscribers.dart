import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/features/profile/presentation/widgets/no_of_followers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoOfSubscribers extends StatelessWidget {
  const NoOfSubscribers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      splashColor: ATColors.white.withValues(alpha: 0.5),
      onTap: () => context.pushNamed(ATRoutes.PROFILE_SUBSCRIBERS_SCREEN),
      child: Row(
        children: <Widget>[
          CustomPaint(
            size: const Size(16, 16),
            painter: RoundedScallopedPainter(color: ATColors.yellowColor),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(Icons.favorite, color: ATColors.black, size: 12),
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            '150k',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: ATSizes.size16),
          ),
          const SizedBox(width: 5),
          Text(
            ATStrings.subscribers,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: ATSizes.size16),
          ),
        ],
      ),
    );
  }
}
