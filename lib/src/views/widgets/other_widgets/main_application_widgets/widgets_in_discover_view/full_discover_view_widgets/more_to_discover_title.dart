import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../config/utils/colors.dart';
import '../../../../../../config/utils/font_sizes.dart';
import '../../../../../../config/utils/other_strings.dart';
import '../../../../../../config/utils/image_strings.dart';

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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
            const SizedBox(height: 4),
            Text(
              ATStrings.SEE_COMMUNITIES,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATSizes.size14,
                    fontWeight: FontWeight.w400,
                    color: ATColors.hexC2C2C2,
                    height: 1.3,
                  ),
            ),
          ],
        ),
        const Spacer(),
        Semantics(
          button: true,
          label: '${ATStrings.VIEW_ALL} ${ATStrings.MORE_2_DISCOVER}',
          child: InkWell(
            onTap: () {
              context.pushNamed(ATRoutes.COMMUNITY_SCREEN);
            },
            borderRadius: BorderRadius.circular(5),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(ATStrings.VIEW_ALL,
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    ATImgStrings.discoverChevronRightIcon,
                    width: 20,
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
