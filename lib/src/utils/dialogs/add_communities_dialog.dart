import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../constants/strings/other_strings.dart';

showAddCommunitiesDialog(BuildContext context)async{
  return showModalBottomSheet(
    backgroundColor: AmptiveColors.brandBlackColor,
    constraints: BoxConstraints.expand(height: AmptiveHelperFunctions.getScreenHeight(context)),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_){
      final listOfItems = ['Music', 'Art', 'Society', 'Technology', 'Sports', 'True Crime', 'Business', 'Society', 'Technology', 'Sports', 'True Crime', 'Business'];
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Gap(20),
            Text(
              AmptiveOtherStrings.ADD_COMMUNITY,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(20),

            Text(
              maxLines: 3,
              AmptiveOtherStrings.ADD_COMMUNITY_DESC,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AmptiveColors.subtitleColor
              ),
            ),
            const Gap(20),

            ...listOfItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [                    
                    const SizedBox(
                      height: 48, width: 67,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.COMMUNITY_CARD)
                      )
                    ),
                    const Gap(15),
                    Text(
                      item,
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                ),
              )
            )
          ]
        ),
      );
    }
  );
}