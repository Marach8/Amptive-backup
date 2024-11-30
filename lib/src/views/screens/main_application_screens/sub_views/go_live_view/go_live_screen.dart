import 'dart:ui';

import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../services/create_show/create_show_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';


class AmptiveMainGoLive extends StatelessWidget {
  const AmptiveMainGoLive({super.key});

  @override
  Widget build(context) {
    CreateShowService service = GetIt.I<CreateShowService>();
    service.initFormControl();

    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          leadingWidth: 30,
          leading: AmptiveCustomContainer(
            height: 30.r, width: 30.r, radius: 30.r, 
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(5),
            color: AmptiveColors.notifRed.withOpacity(0.3),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Icon(Icons.logout, color: AmptiveColors.notifRed)
            )
          ),
          title: Row(
            children: [
              Text(
                AmptiveOtherStrings.LIVE,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Gap(5.w),
              const AmptiveCirceAvatarWidget(diameter: 5),
              Gap(5.w),
              Expanded(
                child: Text(
                  "Don't Forget Who you are by glennodyle",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    overflow: TextOverflow.fade
                  ),
                ),
              )
            ],
          ),
          actions: [
            AmptiveCustomContainer(
              padding: const EdgeInsets.all(5),
              radius: 30,
              color: AmptiveColors.whiteColor.withOpacity(0.1),
              child: Row(
                children: [
                  Text(
                    "🎁",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      overflow: TextOverflow.fade
                    ),
                  ),
                  Text(
                    "Gift",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      overflow: TextOverflow.fade
                    ),
                  ),
                ],
              ),
            ),
            Gap(10.w),

            AmptiveCustomContainer(
              padding: const EdgeInsets.all(5),
              radius: 30,
              color: AmptiveColors.whiteColor.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Iconsax.user, size: 15),
                  Text(
                    "144k",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      overflow: TextOverflow.fade
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        body: Stack(
          children: [
            SizedBox(
              height: AmptiveHelperFunctions.getScreenHeight(context),
              child: Column(
                children: [
                  SizedBox(
                    height: AmptiveHelperFunctions.getScreenHeight(context) * 0.3,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                      itemCount: service.coHostsListData.length,
                      itemBuilder: (_, listIndex){
                        final string = service.coHostsListData.elementAt(listIndex);
                        return ListTile(
                          horizontalTitleGap: 10,
                          leading: AmptiveCircularContainerWithPictureWidget(
                            diameter: 35.h,
                            imagePath: AmptiveImageStrings.CRIMINAL,
                          ),
                          title: Text(
                            string.host.name ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AmptiveColors.subtitleColor
                            )
                          ),
                          subtitle: Text(
                            string.host.username ?? '',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: AmptiveFontSizes.size13
                            )
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            AmptiveCustomContainer(
              height: AmptiveHelperFunctions.getScreenHeight(context) * 0.3,
              color: AmptiveColors.black,
              boxShadow: [
                BoxShadow(
                  color: AmptiveColors.black,
                  spreadRadius: 40, blurRadius: 40,
                  offset: const Offset(0, 40)
                )
              ],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 1,
                    child: AmptiveCircularContainerWithPictureWidget(
                      diameter: 64.h, addBorder: true,
                      borderColor: AmptiveColors.whiteColor,
                      borderWidth: 1, picturePadding: 2,
                      imagePath: AmptiveImageStrings.CRIMINAL,
                    )
                  ),                  
                ],
              )
            ),
          ],
        ),

        bottomSheet: AmptiveCustomContainer(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: AmptiveColors.black,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _listOfWidgets.map(
              (widget){
                final index = _listOfWidgets.indexOf(widget);
                if(index == 1){
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: AmptiveTextFormFieldWidget(
                        controller: TextEditingController(),
                        hintText: AmptiveOtherStrings.COMMENT,
                      ),
                    )
                  );
                }
                return AmptiveCustomContainer(
                  margin: index != 5 ? EdgeInsets.only(right: 5.w) : EdgeInsets.zero,
                  color: AmptiveColors.whiteColor.withOpacity(0.1),
                  padding: const EdgeInsets.all(5),
                  radius: 30,
                  child: widget
                );
              }
            ).toList()
          ),
        ),
      ),
    );
  }
}



List<Widget> _listOfWidgets = [
  const Icon(Icons.settings),
  const Icon(Icons.mic),
  const Icon(Icons.mic),
  const Icon(Icons.front_hand_outlined),
  const RotatedBox(quarterTurns: -45, child: Icon(Icons.logout)),
  const Icon(Icons.add),
];