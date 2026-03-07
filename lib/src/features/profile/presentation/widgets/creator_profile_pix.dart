import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/utils/image_strings.dart';

class CreatorProfilePix extends StatelessWidget {
  const CreatorProfilePix({super.key});

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      decorImage: ATImgStrings.weCanDoHardThingsBgImage,
      height: 150,
      width: context.screenWidth,
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            ATContainer(
              height: 150,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[ATColors.black, ATColors.transparent]),
              width: context.screenWidth,
              child: const SizedBox(),
            ),
            Positioned(
                bottom: -35,
                child: Hero(
                  tag: ATImgStrings.jpeg1,
                  child: ATCircularImage(
                      onTap: () => context.pushNamed(
                          ATRoutes.PROFILE_PIC_SCREEN,
                          extra: ATImgStrings.jpeg1),
                      diameter: 70,
                      addBorder: true,
                      borderColor: ATColors.black,
                      borderWidth: 3,
                      imagePath: ATImgStrings.jpeg1),
                )),
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
                        fontSize: ATSizes.size10, color: ATColors.black),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
