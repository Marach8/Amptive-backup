import 'dart:io';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter/material.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';


void showProgramOptions(BuildContext context)
  => showModalBottomSheet(
      context: context,
      barrierColor: ATColors.black.withValues(alpha: 0.5),
      backgroundColor: ATColors.containerGradientColorB,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        )
      ),
      builder: (_,){
        Map<String, Widget> mapOfOptions = <String, Widget>{
          'Subscribe to glennodoyle': const Icon(Icons.favorite_border_outlined),
          'Follow glennodoyle': const ATImgLoader(
            imgPath: ATImgStrings.followIcon,
            height: 24, width: 24,
          ),
          'Share live': const RotatedBox(
            quarterTurns: 1,
            child: Icon(Icons.logout_outlined),
          ),
          'Not interested': const Icon(Icons.visibility_off_outlined),
          'Report': const Icon(Icons.flag_outlined)
        };
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const ATModalDismisser(),
              const SizedBox(height: 20),
              ...mapOfOptions.entries.map(
                (MapEntry<String, Widget> entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: <Widget>[
                      entry.value,
                      const SizedBox(width: 15),
                      Text(
                        entry.key,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: ATColors.white,
                          fontSize: ATSizes.size17
                        ),
                      )
                    ],
                  ),
                )
              ),
            ],
          ),
        );
    }
  );
