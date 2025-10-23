import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../bloc/main_app/profile/profile_menu/calender/calender_visibile_bloc.dart';

class AmptiveProfileMenuScreen extends StatelessWidget {
  const AmptiveProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const SizedBox(
              height: 30, width: 30,
              child: Icon(Icons.keyboard_arrow_left_outlined),
            ),
          ),
          leadingWidth: 30,
          title: Text(
            ATStrings.MENU,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const MenuHeading(text: ATStrings.CALENDER),
              MenuItem(
                firstIcon: const ATImgLoader(imgPath: ATImgStrings.CALENDER_ICON),
                middleText: ATStrings.VIEW_CALENDER,
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                onTap: () => context.pushNamed(ATRoutes.CALENDER_SCREEN)
              ),
              MenuItem(
                firstIcon: const Icon(Icons.visibility_outlined),
                middleText: ATStrings.ALLOW_SEE_CALENDER,
                margin: const EdgeInsets.fromLTRB(15, 0, 5, 5),
                lastIcon: BlocConsumer<CalenderVisibleBloc, bool>(
                  listener: (_, bool state){
                    if(state){
                      showAppNotification(
                        context: context,
                        icon: const Icon(Icons.check_circle),
                        text: ATStrings.USERS_CAN_SEE_UR_CALENDER
                      );
                    }
                  },
                  builder: (_, bool state)  => ATSwitch(
                    value: state,
                    onChanged: (bool value){
                      context.read<CalenderVisibleBloc>().toggleSeeCalender();
                    }
                  )
                ),
                onTap: (){}
              ),

              const MenuHeading(text: ATStrings.ACCT_SETTINGS),
              MenuItem(
                firstIcon: const Icon(Icons.account_circle_outlined),
                middleText: ATStrings.ACCT,
                onTap: () => context.pushNamed(ATRoutes.ACCT_SCREEN)
              ),
              MenuItem(
                firstIcon: const Icon(Icons.lock_outline_rounded),
                middleText: ATStrings.PRIVACY,
                onTap: () => context.pushNamed(ATRoutes.PRIVACY_SCREEN)
              ),
              MenuItem(
                firstIcon: const Icon(Icons.password),
                middleText: ATStrings.PSWRD_ND_SECURITY,
                onTap: (){}
              ),

              const MenuHeading(text: ATStrings.APP_SETTINGS),
              MenuItem(
                firstIcon: const Icon(Icons.settings_outlined),
                middleText: ATStrings.SETTINGS,
                onTap: (){}
              ),
              MenuItem(
                firstIcon: const Icon(Iconsax.global),
                middleText: ATStrings.LANGUAGE,
                onTap: () => context.pushNamed(ATRoutes.LANGUAGE_SCREEN)
              ),
              MenuItem(
                firstIcon: const ATImgLoader(
                  imgPath: ATImgStrings.SUBSCRIBER_BADGE,
                ),
                middleText: ATStrings.SUBSCRIPTION,
                onTap: (){}
              ),

              const MenuHeading(text: ATStrings.HELP_SUPPORT),
              MenuItem(
                firstIcon: const Icon(Icons.info_outline_rounded),
                middleText: ATStrings.ABOUT,
                onTap: (){}
              ),
              MenuItem(
                firstIcon: const Icon(Iconsax.message),
                middleText: ATStrings.HELP_SUPPORT,
                onTap: (){}
              ),

              const SizedBox(height: 20),
              MenuItem(
                firstIcon: const Icon(Icons.logout),
                middleText: ATStrings.LOGOUT,
                onTap: (){}
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.firstIcon,
    required this.middleText,
    this.lastIcon,
    this.margin,
    required this.onTap
  });
  final Widget firstIcon;
  final Widget? lastIcon;
  final String middleText;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      margin: margin ?? const EdgeInsets.fromLTRB(15, 0, 15, 20),
      onTap: onTap,
      child: Row(
        children: <Widget>[
          firstIcon,
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              middleText,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: ATColors.white
              ),
            ),
          ),
          lastIcon ?? Icon(Icons.keyboard_arrow_right_outlined, color: ATColors.hexC2C2C2)
        ],
      ),
    );
  }
}


class MenuHeading extends StatelessWidget {
  const MenuHeading({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) 
    => Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: ATColors.hexC2C2C2
        ),
      ),
    );
}