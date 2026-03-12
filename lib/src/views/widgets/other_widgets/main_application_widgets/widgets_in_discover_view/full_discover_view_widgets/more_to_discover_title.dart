import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../config/utils/colors.dart';
import '../../../../../../config/utils/font_sizes.dart';
import '../../../../../../config/utils/other_strings.dart';

class AmptiveMore2DiscoverTitle extends StatelessWidget {
  const AmptiveMore2DiscoverTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(ATStrings.MORE_2_DISCOVER,
                style: Theme.of(context).textTheme.bodyLarge),
            Text(
              ATStrings.SEE_COMMUNITIES,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: ATSizes.size13, color: ATColors.hexCDCDCD),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            context.pushNamed(ATRoutes.COMMUNITY_SCREEN);
          },
          borderRadius: BorderRadius.circular(5),
          child: Row(
            children: <Widget>[
              Text(ATStrings.VIEW_ALL,
                  style: Theme.of(context).textTheme.labelMedium),
              Icon(
                Icons.keyboard_arrow_right_sharp,
                color: ATColors.hexB6B6B6,
              )
            ],
          ),
        )
      ],
    );
  }
}
