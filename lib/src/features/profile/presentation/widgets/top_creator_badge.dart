import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/profile/presentation/widgets/top_creators_communities_modal.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';

import '../../../../config/utils/image_strings.dart';
import '../../../../shared/image_loader_widget.dart';

class TopCreatorBadge extends StatelessWidget {
  const TopCreatorBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: () => showTopCreationCommunitiesModal(context),
      border: Border.all(color: ATColors.hexC2C2C2.withValues(alpha: 0.23)),
      radius: 20,
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            ATColors.white.withValues(alpha: 0.1),
            ATColors.hex303030.withValues(alpha: 0.1),
            ATColors.white.withValues(alpha: 0.1),
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: <Widget>[
          const ATImgLoader(
            imgPath: ATImgStrings.topCreatorIcon,
            height: 13, width: 13,
          ),
          Text(
            ATStrings.topCreatorInSociety,
            style: context
                .textTheme
                .bodySmall
                ?.copyWith(color: ATColors.hexEECEA0, fontSize: ATSizes.size13),
          ),
        ],
      ),
    );
  }
}
