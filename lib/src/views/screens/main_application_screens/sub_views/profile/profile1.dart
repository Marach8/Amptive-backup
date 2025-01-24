import 'package:amptive/src/routes.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/two_texts_rich_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/dialogs/go_live/follow_or_subscribe_dialog.dart';

class Profile1Widget extends StatelessWidget {
  const Profile1Widget({super.key});

  @override
  Widget build(context) {
    return AmptiveAnnotatedRegionWidget(
      statusBarColor: AmptiveColors.transparentColor,
      child: Scaffold(
       // appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AmptiveCustomContainer(
              decorationImagePath: AmptiveImageStrings.weCanDoHardThingsBgImage,
              height: 150,
              width: AmptiveHelperFunctions.getScreenWidth(context),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 15,
                    child: AmptiveCirceAvatarWidget(
                      onTap: () => context.pop(),
                      diameter: 30, color: AmptiveColors.black.withOpacity(0.7),
                      child: const Icon(Icons.keyboard_arrow_left),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    child: AmptiveCirceAvatarWidget(
                      diameter: 30, color: AmptiveColors.black.withOpacity(0.7),
                      child: const Icon(Icons.menu, size: 20),
                    ),
                  ),
                  Positioned(
                    right: 50,
                    child: AmptiveCirceAvatarWidget(
                      diameter: 30, color: AmptiveColors.black.withOpacity(0.7),
                      child: const Icon(Iconsax.global, size: 20),
                    ),
                  ),
                  Positioned(
                    bottom: -35,
                    child: AmptiveCircularContainerWithPictureWidget(
                      diameter: 70, addBorder: true,
                      borderColor: AmptiveColors.black,
                      borderWidth: 3,
                      imagePath: AmptiveImageStrings.jpeg1
                    )
                  ),
                  Positioned(
                    bottom: -35,
                    child: AmptiveCustomContainer(
                      color: AmptiveColors.yellowColor1,
                      radius: 10,
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 1),
                      border: Border.all(color: AmptiveColors.black, width: 2),
                      child: Text(
                        AmptiveOtherStrings.CREATOR.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AmptiveFontSizes.size10,
                          color: AmptiveColors.black
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
            
            const Gap(50),

            Text(
              'Glennon Doyle',
              style: Theme.of(context).textTheme.bodyLarge
            ),
            Text(
              'Glennondoyle',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AmptiveColors.hexC2C2C2
              ),
            ),

            const Gap(20),

            AmptiveCustomContainer(
              border: Border.all(color: AmptiveColors.hexC2C2C2.withOpacity(0.23)),
              radius: 20,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AmptiveColors.whiteColor.withOpacity(0.1),
                  AmptiveColors.hex303030.withOpacity(0.1),
                  AmptiveColors.whiteColor.withOpacity(0.1),
                ]
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.TOP_CREATOR_BADGE),
                  const Gap(5),
                  Text(
                    AmptiveOtherStrings.TOP_CREATORS_IN_SOCIETY,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AmptiveColors.hexEECEA0,
                      fontSize: AmptiveFontSizes.size13
                    ),
                  ),
                ],
              ),
            ),

            const Gap(20),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                  size: const Size(16, 16),
                  painter: RoundedScallopedPainter(
                    color: AmptiveColors.dimWhiteColor1
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(Icons.star, color: AmptiveColors.black, size: 12),
                  ),
                ),
                Text(
                  '1.1m',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: AmptiveFontSizes.size16
                  ),
                ),
                const Gap(5),
                Text(
                  AmptiveOtherStrings.FOLLOWERS,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: AmptiveFontSizes.size16
                  ),
                ),
                const Gap(20),
              
                CustomPaint(
                  size: const Size(16, 16),
                  painter: RoundedScallopedPainter(
                    color: AmptiveColors.yellowColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(Icons.favorite, color: AmptiveColors.black, size: 12),
                  ),
                ),
                Text(
                  '150k',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: AmptiveFontSizes.size16
                  ),
                ),
                const Gap(5),
                Text(
                  AmptiveOtherStrings.SUBSCRIBERS,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: AmptiveFontSizes.size16
                  ),
                ),
              ],
            ),

            const Gap(20),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: AmptiveMultipleTextsRichText(
                items: {
                  'Author of UNTAMED & LOVE WARRIOR. Host of WE CAN DO HARD THINGS. Founder of'
                  : Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: AmptiveFontSizes.size13
                  ),
                  ' @together_rising. ': Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: AmptiveFontSizes.size13,
                    color: AmptiveColors.hexC2C2C2
                  ),
                  'Includes an Oscar winner.': Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: AmptiveFontSizes.size13
                  ),
                },
                textAlign: TextAlign.center,
                textOnTap: (index){
                  if(index == 1){
                    print("Hello");
                  }
                },
              ),
            ),

            const Gap(20),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.instagram, color: AmptiveColors.hexC2C2C2, size: 15,),
                const Gap(3),
                Text(
                  AmptiveOtherStrings.INSTAGRAM,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AmptiveColors.hexC2C2C2
                  ),
                ),
                const Gap(15),
                const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.X_LOGO),
                const Gap(3),
                Text(
                  'x',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AmptiveColors.hexC2C2C2
                  ),
                ),
                const Gap(15),
                FaIcon(FontAwesomeIcons.linkedin, color: AmptiveColors.hexC2C2C2, size: 15),
                const Gap(3),
                Text(
                  AmptiveOtherStrings.LINKEDIN,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AmptiveColors.hexC2C2C2
                  ),
                ),
                const Gap(15),
                Transform.rotate(
                  angle: -0.9,
                  child: Icon(Icons.insert_link, color: AmptiveColors.hexC2C2C2, size: 15,),
                ),
                const Gap(3),
                Text(
                  AmptiveOtherStrings.WEBSITE,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AmptiveColors.hexC2C2C2
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}