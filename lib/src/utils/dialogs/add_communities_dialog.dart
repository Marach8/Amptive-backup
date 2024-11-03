import 'package:amptive/src/routes.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../constants/strings/other_strings.dart';

Future<void> showAddCommunitiesDialog({
  required BuildContext context,
  required ValueNotifier<List<String>> notifier
})async{
  return await showModalBottomSheet(
    backgroundColor: AmptiveColors.brandBlackColor,
    constraints: BoxConstraints.expand(height: AmptiveHelperFunctions.getScreenHeight(context)),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_){
      final communityNames = ['Music', 'Art', 'Society', 'Technology', 'Sports', 'True Crime', 'Business', 'Society', 'Technology', 'Sports', 'True Crime', 'Business'];
      final communityCards = List.generate(
        communityNames.length,
        (_) => AmptiveImageStrings.COMMUNITY_CARD
      );
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

            ...communityNames.map(
              (name) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    final index = communityNames.indexOf(name);
                    final selectedCard = communityCards.elementAt(index);
                    notifier.value = [selectedCard, name];
                    context.pop();
                  },
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
                        name,
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    ],
                  ),
                ),
              )
            )
          ]
        ),
      );
    }
  );
}