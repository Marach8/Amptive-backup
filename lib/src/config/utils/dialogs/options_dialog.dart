import 'dart:io';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../views/widgets/common_widgets/custom_container_widget.dart';
import '../colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';


void showProgramOptions(BuildContext context)
  => showModalBottomSheet(
      context: context,
      barrierColor: ATColors.black.withOpacity(0.5),
      backgroundColor: ATColors.containerGradientColorB,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        )
      ),
      builder: (_,){
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => ATHelperFuncs.hideAnyMountedSnackbar(context),
                  child: Platform.isAndroid
                    ? Icon(
                      Icons.keyboard_arrow_down, size: 30,
                      color: ATColors.white.withOpacity(0.6),
                    ) : ATContainer(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      radius: 5, height: 4, width: 30,
                      color: ATColors.white.withOpacity(0.6),
                      child: const SizedBox.shrink(),
                    ),
                ),
              ),
              const Gap(20),
              ...mapOfOptions.entries.map(
                (MapEntry<String, Widget> entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      entry.value,
                      const Gap(15),
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: ATColors.white,
                          fontSize: ATFontSizes.size17
                        ),
                      )
                    ],
                  ),
                )
              )
            ],
          ),
        );
    }
  );


  Map<String, Widget> mapOfOptions = <String, Widget>{
  'Subscribe to glennodoyle': const Icon(Icons.favorite_border_outlined),
  'Follow glennodoyle': const ATImgLoader(imgPath: ATImgStrings.FOLLOW_ICON),
  'Share live': const ATImgLoader(imgPath: ATImgStrings.SHARE_LIVE),
  'Not interested': const Icon(Icons.visibility_off_outlined),
  'Report': const Icon(Icons.flag_outlined)
};