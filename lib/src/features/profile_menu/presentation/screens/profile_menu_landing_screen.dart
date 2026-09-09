import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/logout_cubit.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/confirmation_alert_dialog.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../calender/cubits/calender_visibile_bloc.dart';

class AmptiveProfileMenuScreen extends StatelessWidget {
  const AmptiveProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogoutCubit>(
      create: (_) => LogoutCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: const ATAppBar(
            leadingWidth: 30,
            padding: EdgeInsets.only(left: 7),
            leading: ATRoundedBackBtn(),
            titleText: ATStrings.menu,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const MenuHeading(text: ATStrings.calender),
                MenuItem(
                  leading: const ATImgLoader(
                    height: 24, width: 24,
                    imgPath: ATImgStrings.calenderIcon
                  ),
                middleText: ATStrings.viewCalender,
                onTap: () => context.pushNamed(ATRoutes.CALENDER_SCREEN)),
                MenuItem(
                  onTap: null,
                  leading: const Icon(Icons.visibility_outlined),
                  middleText: ATStrings.GRANT_CALENDER_ACCESS,
                  margin: const EdgeInsets.fromLTRB(15, 0, 5, 5),
                  lastIcon: BlocConsumer<CalenderVisibleBloc, bool>(
                      listener: (_, bool state) {
                        if (state) {
                          showAppNotification(
                              context: context,
                              icon: const Icon(Icons.check_circle),
                              text: ATStrings.USERS_CAN_SEE_UR_CALENDER);
                        }
                      },
                      builder: (_, bool state) => ATSwitch(
                          value: state,
                          onChanged: (bool value) {
                            context
                                .read<CalenderVisibleBloc>()
                                .toggleSeeCalender();
                          })),
                ),
                const MenuHeading(text: ATStrings.ACCT_SETTINGS),
                MenuItem(
                    leading: const Icon(Icons.account_circle_outlined),
                    middleText: ATStrings.account,
                    onTap: () =>
                        context.pushNamed(ATRoutes.accountLandingScreen)),
                MenuItem(
                    leading: const Icon(Icons.lock_outline_rounded),
                    middleText: ATStrings.privacy,
                    onTap: () => context.pushNamed(ATRoutes.PRIVACY_SCREEN)),
                MenuItem(
                    leading: const Icon(Icons.password),
                    middleText: ATStrings.PSWRD_ND_SECURITY,
                    onTap: () {}),
                const MenuHeading(text: ATStrings.APP_SETTINGS),
                MenuItem(
                    leading: const Icon(Icons.settings_outlined),
                    middleText: ATStrings.SETTINGS,
                    onTap: () {}),
                MenuItem(
                    leading: const Icon(Iconsax.global),
                    middleText: ATStrings.language,
                    onTap: () => context.pushNamed(ATRoutes.LANGUAGE_SCREEN)),
                MenuItem(
                    leading: const ATImgLoader(
                      height: 24, width: 24,
                      imgPath: ATImgStrings.subscriberBadge,
                    ),
                    middleText: ATStrings.subscription,
                    onTap: () {}),
                const MenuHeading(text: ATStrings.HELP_SUPPORT),
                MenuItem(
                    leading: const Icon(Icons.info_outline_rounded),
                    middleText: ATStrings.ABOUT,
                    onTap: () {}),
                MenuItem(
                    leading: const Icon(Iconsax.message),
                    middleText: ATStrings.HELP_SUPPORT,
                    onTap: () {}),
                const SizedBox(height: 20),
      
                BlocConsumer<LogoutCubit, ATAppState<bool>>(
                  listener: (_, ATAppState<bool> state){
                    if(context.mounted && state is SuccessState<bool>){
                      context.goNamed(ATRoutes.temporaryLoginScreen);
                    }
                  },
                  builder: (BuildContext ctx, ATAppState<bool> state) {
                    final bool isLogginOut = state is LoadingState<bool>;
                    return MenuItem(
                        leading: const Icon(Icons.logout),
                        middleText: ATStrings.logout,
                        lastIcon: isLogginOut ? ATLoadingIndicator(
                          size: 20, color: ATColors.white
                        ) : null,
                        onTap: isLogginOut ? null : ()async{
                          final bool? shouldLogOut = await showConfirmationDialog(
                            context: context, 
                            title: ATStrings.logout,
                            content: 'Are you sure you want to Logout?',
                            yesString: 'Logout',
                            noString: 'Cancel'
                          );
                          if(ctx.mounted && shouldLogOut == true){
                            ctx.read<LogoutCubit>().logout();
                          }
                        }
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {super.key,
      required this.leading,
      required this.middleText,
      this.lastIcon,
      this.margin,
      required this.onTap});
  final Widget leading;
  final Widget? lastIcon;
  final String middleText;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      margin: margin ?? const EdgeInsets.fromLTRB(15, 12, 15, 12),
      onTap: onTap,
      child: Row(
        children: <Widget>[
          leading,
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              middleText,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: ATColors.white),
            ),
          ),
          lastIcon ??
              Icon(Icons.keyboard_arrow_right_outlined,
                  color: ATColors.hexC2C2C2)
        ],
      ),
    );
  }
}

class MenuHeading extends StatelessWidget {
  const MenuHeading({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 16),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: ATColors.hexC2C2C2),
        ),
      );
}
