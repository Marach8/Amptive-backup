import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class EditProfileAndSubscriptionRow extends StatelessWidget {
  const EditProfileAndSubscriptionRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: ATContainer(
            onTap: () => context.pushNamed(ATRoutes.EDIT_PROFILE),
            alignment: Alignment.center, radius: 50,
            margin: const EdgeInsets.only(left: 15),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            color: ATColors.white.withOpacity(0.2),
            child: Text(
              ATStrings.EDIT_PROFILE,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: ATSizes.size14
              )
            )
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ATContainer(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            margin: const EdgeInsets.only(right: 15),
            alignment: Alignment.center, radius: 50,
            color: ATColors.white.withOpacity(0.2),
            child: Text(
              ATStrings.SUBSCRIPTION,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: ATSizes.size14
              )
            )
          ),
        )
      ]
    );
  }
}
