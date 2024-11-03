import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../../../utils/constants/colors.dart';
import '../../../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../../widgets/common_widgets/app_bar_widget.dart';
import '../../../../../../../widgets/common_widgets/elevated_button_widget.dart';

class AmptiveEventScheduledScreen extends StatelessWidget {
  const AmptiveEventScheduledScreen({super.key});

  @override
  Widget build(context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          leading: GestureDetector(
            onTap: (){context.pop();},
            child: const Icon(Icons.close, size: 20,)
          ),
          leadingWidth: 20,
        ),

        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                AmptiveCirceAvatarWidget(
                  diameter: 45,
                  color: AmptiveColors.whiteColor,
                  child: Icon(Icons.calendar_today_outlined, color: AmptiveColors.black,),
                ),
                const Gap(5),
                Text(
                  AmptiveOtherStrings.EVENT_SCHEDULED,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: AmptiveFontSizes.size23
                  )
                ),
                Text(
                  AmptiveOtherStrings.SHARE_EVENT_LINK,
                  maxLines: 2, textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium
                ),
              ],
            ),
          ),
        ),

        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AmptiveElevatedButtonWidget(
              onPressed: (){},
              buttonTitle: AmptiveOtherStrings.SHARE_EVENT,
              bgColor: AmptiveColors.whiteColor,
              fgColor: AmptiveColors.black,
            ),
            const Gap(10),
            GestureDetector(
              onTap: (){},
              child: Text(
                AmptiveOtherStrings.VIEW_EVENT_PAGE,
                style: Theme.of(context).textTheme.bodyMedium
              ),
            )
          ],
        ),
      ),
    );
  }
}