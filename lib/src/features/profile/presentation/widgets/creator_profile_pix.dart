import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/constants/strings/image_strings.dart';
import '../../../../utils/helpers/helper_functions/other_functions.dart';

class CreatorProfilePix extends StatelessWidget {
  const CreatorProfilePix({super.key});

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      decorationImagePath: ATImgStrings.weCanDoHardThingsBgImage,
      height: 150,                
      width: ATHelperFuncs.getScreenWidth(context),
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            ATContainer(
              height: 150,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ATColors.black,
                  ATColors.trsprnt,
                  ATColors.trsprnt
                ]
              ),
              width: ATHelperFuncs.getScreenWidth(context),
              child: const SizedBox(),
            ),
            Positioned(
              bottom: -35,
              child: Hero(
                tag: ATImgStrings.jpeg1,
                child: ATCircularImage(
                  onTap: () => context.pushNamed(
                    ATRoutes.PROFILE_PIC_SCREEN,
                    extra: ATImgStrings.jpeg1
                  ),
                  diameter: 70, addBorder: true,
                  borderColor: ATColors.black,
                  borderWidth: 3,
                  imagePath: ATImgStrings.jpeg1
                ),
              )
            ),
            Positioned(
              bottom: -35,
              child: ATContainer(
                color: ATColors.hexFED601,
                radius: 10,
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 1),
                border: Border.all(color: ATColors.black, width: 2),
                child: Text(
                  ATStrings.CREATOR.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ATFontSizes.size10,
                    color: ATColors.black
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}