import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';

class AmptiveMore2DiscoverTitle extends StatelessWidget {
  const AmptiveMore2DiscoverTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AmptiveStrings.MORE_2_DISCOVER,
              style: Theme.of(context).textTheme.bodyLarge 
            ),
            Text(
              AmptiveStrings.SEE_COMMUNITIES,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: AmptiveFontSizes.size13,
                color: AmptiveColors.authHintColor2
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: (){
            context.pushNamed(ATRoutes.COMMUNITY_SCREEN);
          },
          child: Row(
            children: [
              Text(
                AmptiveStrings.VIEW_ALL,
                style: Theme.of(context).textTheme.labelMedium
              ),
              Icon(Icons.keyboard_arrow_right_sharp, color: AmptiveColors.authHintColor,)
            ],
          ),
        )
      ],
    );
  }
}