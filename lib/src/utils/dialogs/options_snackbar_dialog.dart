import 'dart:io';
import 'package:amptive/src/utils/constants/maps.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../views/widgets/common_widgets/container_for_rendering_other_widgets.dart';
import '../constants/colors.dart';

void showAudioOrVideoFullDetailsOptions(BuildContext context)
  => ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      backgroundColor: AmptiveColors.containerGradientColorB,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        )
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      duration: const Duration(hours: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => AmptiveHelperFunctions.hideAnyMountedSnackbar(context),
              child: Platform.isAndroid
                ? Icon(
                  Icons.keyboard_arrow_down,
                  color: AmptiveColors.whiteColor.withOpacity(0.6),
                )
                : AmptiveCustomContainer(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  radius: 5, height: 4, width: 30,
                  color: AmptiveColors.whiteColor.withOpacity(0.6),
                  child: const SizedBox.shrink(),
                ),
            ),
          ),
          const Gap(20),
          ...mapOfOptions.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  entry.value,
                  const Gap(15),
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AmptiveColors.whiteColor
                    ),
                  )
                ],
              ),
            )
          )
        ],
      )
    )
  );