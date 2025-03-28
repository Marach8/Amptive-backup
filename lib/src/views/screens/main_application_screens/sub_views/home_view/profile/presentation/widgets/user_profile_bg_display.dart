import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/profile/show_top_creator_societies.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../utils/constants/font_weights.dart';
import '../../../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../../../utils/helpers/helper_functions/other_functions.dart';
import '../../../../../../../widgets/common_widgets/custom_container_widget.dart';
import '../../../../../../../widgets/common_widgets/image_loader_widget.dart';
import '../../bloc/profile_bloc_export.dart';

class UserBgProfileWidget extends StatelessWidget {
  const UserBgProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      color: ATColors.white.withOpacity(0.5),
      height: 150,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          ATColors.black,
          ATColors.white.withOpacity(0.5),
          ATColors.hexD9D9D9
        ]
      ),
      width: ATHelperFuncs.getScreenWidth(context),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -35,
            child: ATCircularImage(
              onTap: () => context.pushNamed(
                ATRoutes.PROFILE_PIC_SCREEN,
                extra: ATImgStrings.jpeg2
              ),
              diameter: 70, addBorder: true,
              borderColor: ATColors.black,
              borderWidth: 3,
              imagePath: ATImgStrings.jpeg2
            )
          ),
        ],
      ),
    );
  }
}
