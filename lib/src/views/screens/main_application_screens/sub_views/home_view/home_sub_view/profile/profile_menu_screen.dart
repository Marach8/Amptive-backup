import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class AmptiveProfileMenuScreen extends StatelessWidget {
  const AmptiveProfileMenuScreen({super.key});

  @override
  Widget build(context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const SizedBox(
              height: 30, width: 30,
              child: Icon(Icons.keyboard_arrow_left_outlined),
            ),
          ),
          leadingWidth: 30,
          title: Text(
            AmptiveStrings.MENU,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MenuHeading(text: AmptiveStrings.CALENDER),
              _MenuItem(
                firstIcon: const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.CALEND_ICON),
                middleText: AmptiveStrings.VIEW_CALENDER,
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                onTap: (){}
              ),
              _MenuItem(
                firstIcon: const Icon(Icons.visibility_outlined),
                middleText: AmptiveStrings.ALLOW_SEE_CALENDER,
                margin: const EdgeInsets.fromLTRB(15, 0, 5, 5),
                lastIcon: AmptiveSwitch(
                  value: false,
                  onChanged: (value){}
                ),
                onTap: (){}
              ),

              const _MenuHeading(text: AmptiveStrings.ACCT_SETTINGS),
              _MenuItem(
                firstIcon: const Icon(Icons.account_circle_outlined),
                middleText: AmptiveStrings.ACCT,
                onTap: (){}
              ),
              _MenuItem(
                firstIcon: const Icon(Icons.lock_outline_rounded),
                middleText: AmptiveStrings.PRIVACY,
                onTap: (){}
              ),
              _MenuItem(
                firstIcon: const Icon(Icons.password),
                middleText: AmptiveStrings.PSWRD_ND_SECURITY,
                onTap: (){}
              ),

              const _MenuHeading(text: AmptiveStrings.APP_SETTINGS),
              _MenuItem(
                firstIcon: const Icon(Icons.settings_outlined),
                middleText: AmptiveStrings.SETTINGS,
                onTap: (){}
              ),
              _MenuItem(
                firstIcon: const Icon(Iconsax.global),
                middleText: AmptiveStrings.LANGUAGE,
                onTap: (){}
              ),
              _MenuItem(
                firstIcon: const AmptiveImageLoaderWidget(
                  imagePath: AmptiveImageStrings.SUBSCRIBER_BADGE,
                ),
                middleText: AmptiveStrings.SUBSCRIPTION,
                onTap: (){}
              ),

              const _MenuHeading(text: AmptiveStrings.HELP_SUPPORT),
              _MenuItem(
                firstIcon: const Icon(Icons.info_outline_rounded),
                middleText: AmptiveStrings.ABOUT,
                onTap: (){}
              ),
              _MenuItem(
                firstIcon: const Icon(Iconsax.message),
                middleText: AmptiveStrings.HELP_SUPPORT,
                onTap: (){}
              ),

              const Gap(20),
              _MenuItem(
                firstIcon: const Icon(Icons.logout),
                middleText: AmptiveStrings.LOGOUT,
                onTap: (){}
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _MenuItem extends StatelessWidget {
  final Widget firstIcon;
  final Widget? lastIcon;
  final String middleText;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;
  const _MenuItem({
    required this.firstIcon,
    required this.middleText,
    this.lastIcon,
    this.margin,
    required this.onTap
  });

  @override
  Widget build(context) {
    return AmptiveCustomContainer(
      margin: margin ?? const EdgeInsets.fromLTRB(15, 0, 15, 20),
      onTap: onTap,
      child: Row(
        children: [
          firstIcon,
          const Gap(15),
          Expanded(
            child: Text(
              middleText,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AmptiveColors.whiteColor
              ),
            ),
          ),
          lastIcon ?? Icon(Icons.keyboard_arrow_right_outlined, color: AmptiveColors.hexC2C2C2)
        ],
      ),
    );
  }
}


class _MenuHeading extends StatelessWidget {
  final String text;
  const _MenuHeading({required this.text});

  @override
  Widget build(BuildContext context) 
    => Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AmptiveColors.hexC2C2C2
        ),
      ),
    );
}