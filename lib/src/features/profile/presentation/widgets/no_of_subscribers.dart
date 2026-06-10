import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
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
    required this.noOfSubscribers,
  });

  final int? noOfSubscribers;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      splashColor: ATColors.white.withValues(alpha: 0.5),
      onTap: () => context.pushNamed(ATRoutes.creatorSubscribersScreen),
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
          const SizedBox(width: 2),
          Text(
            (noOfSubscribers ?? 0).toString(),
            style: context
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: ATSizes.size16),
          ),
          const SizedBox(width: 5),
          Text(
            ATStrings.subscribers,
            style: context
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: ATSizes.size16),
          ),
        ],
      ),
    );
  }
}
