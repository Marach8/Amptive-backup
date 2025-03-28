import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/profile/show_top_creator_societies.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../utils/constants/font_weights.dart';
import '../../../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../../../utils/helpers/helper_functions/other_functions.dart';
import '../../../../../../../widgets/common_widgets/custom_container_widget.dart';
import '../../../../../../../widgets/common_widgets/image_loader_widget.dart';

class EditProfileAndSubscriptionRow extends StatelessWidget {
  const EditProfileAndSubscriptionRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
                fontSize: ATFontSizes.size14
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
                fontSize: ATFontSizes.size14
              )
            )
          ),
        )
      ]
    );
  }
}