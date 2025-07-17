import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/features/profile/presentation/views/profile_menu/profile_menu_landing_screen.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../bloc/main_app/profile/private_account_bloc.dart';
import '../../../../../../config/utils/other_strings.dart';
import '../../../../../../config/routing/route_strings.dart';
import '../../../../../../config/utils/dialogs/app_notification_dialog.dart';
import '../../../../../../views/widgets/common_widgets/circle_avatar.dart';
import '../../../../../../views/widgets/common_widgets/switch_widget.dart';



class AmptivePrivacyScreen extends StatelessWidget {
  const AmptivePrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 15),
              child: Row(
                children: <Widget>[
                  ATCircleAvatar(
                    onTap: () => context.pop(),
                    diameter: 30, color: ATColors.trsprnt,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const Spacer(),
                  Text(
                    ATStrings.PRIVACY,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_left, color: ATColors.trsprnt),
                ],
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          ATStrings.PRIVATE_ACCT,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: ATColors.white
                          )
                        ),
                        const Spacer(),
                        BlocConsumer<PrivateAccountBloc, bool>(
                          listener: (_, bool state){
                            if(state){
                              showAppNotification(
                                context: context,
                                icon: const Icon(Icons.check_circle),
                                text: ATStrings.ACCT_PRIVATE
                              );
                            }
                          },
                          builder: (_, bool state)  => AmptiveSwitch(
                            value: state,
                            onChanged: (bool value){
                              context.read<PrivateAccountBloc>().togglePrivateAcct();
                            }
                          )
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Text(
                      ATStrings.APPROVED_USERS_CAN_FOLLOW,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: ATFontWeights.w500,
                        color: ATColors.white.withValues(alpha: 0.4)
                      )
                    ),
                  ),
                  const MenuHeading(text: ATStrings.MUTES_ND_BLOCKS),
                  MenuItem(
                    firstIcon: const Icon(Icons.notifications_off_outlined),
                    middleText: ATStrings.MUTED_ACCTS,
                    onTap: () => context.pushNamed(ATRoutes.MUTED_ACCTS_SCREEN)
                  ),
                  MenuItem(
                    firstIcon: const Icon(Icons.block),
                    middleText: ATStrings.BLOCKED_ACCTS,
                    onTap: () => context.pushNamed(ATRoutes.BLOCKED_ACCTS_SCREEN)
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}