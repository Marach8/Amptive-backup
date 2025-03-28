import 'package:amptive/src/bloc/main_app/profile/profile_followers_bloc.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocked_accts.dart';

class AmptiveMutedAcctsScreen extends StatelessWidget {
  const AmptiveMutedAcctsScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 15),
              child: Row(
                children: [
                  AmptiveCircleAvatarWidget(
                    onTap: () => context.pop(),
                    diameter: 30, color: ATColors.trsprnt,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const Spacer(),
                  Text(
                    ATStrings.MUTED_ACCTS,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_left, color: ATColors.trsprnt),
                ],
              ),
            ),

            BlocBuilder<AmptiveProfileFollowersBloc, List<ObjectWithNotifier<Host>>>(
              builder: (_, state) {
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 50),
                    itemCount: state.length,
                    itemBuilder: (_, listIndex){
                      final subscriber = state.elementAt(listIndex);
                      return AmptiveBlockedOrMutedAcctWidget(
                        subscriber: subscriber,
                        text: ATStrings.UNMUTE,
                        onTap: (follower, isSelected)async{
                          final shouldUnmute = await showConfirmationDialog(
                            context: context,
                            title: '${ATStrings.UNMUTE} ${follower.obj.username}',
                            content: ATStrings.unMuteDesc(follower.obj.username ?? ''),
                            yesString: ATStrings.UNMUTE,
                            noString: ATStrings.CANCEL
                          );
                          if(context.mounted && (shouldUnmute ?? false)){
                            showAppNotification(
                              context: context,
                              icon: const Icon(Icons.check_circle),
                              text: '${follower.obj.username} ${ATStrings.IS_UNMUTED}'
                            );
                          }
                        },
                      );
                    }
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}