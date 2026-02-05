import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/image_strings.dart';

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
        colors: <Color>[
          ATColors.black,
          ATColors.white.withOpacity(0.5),
          ATColors.hexD9D9D9
        ]
      ),
      width: context.screenWidth,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
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
