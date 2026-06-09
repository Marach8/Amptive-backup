import 'package:amptive/src/bloc/main_app/profile/profile_followers_bloc.dart';
import 'package:amptive/src/features/privacy/presentation/widgets/render_blocked_or_muted_account.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/shared/confirmation_alert_dialog.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveMutedAcctsScreen extends StatelessWidget {
  const AmptiveMutedAcctsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leadingWidth: 30,
          padding: EdgeInsets.only(left: 7),
          leading: ATRoundedBackBtn(),
          titleText: ATStrings.mutedAccounts,
        ),
        body: BlocBuilder<AmptiveProfileFollowersBloc,
                List<ObjectWithNotifier<Host>>>(
            builder: (_, List<ObjectWithNotifier<Host>> state) {
          return Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 50),
                itemCount: state.length,
                itemBuilder: (_, int listIndex) {
                  final ObjectWithNotifier<Host> subscriber =
                      state.elementAt(listIndex);
                  return RenderBlockedOrMutedAccount(
                    subscriber: subscriber,
                    text: ATStrings.UNMUTE,
                    onTap: (ObjectWithNotifier<Host> follower,
                        bool isSelected) async {
                      final bool? shouldUnmute = await showConfirmationDialog(
                          context: context,
                          title: '${ATStrings.UNMUTE} ${follower.obj.username}',
                          content:
                              ATStrings.unMuteDesc(follower.obj.username ?? ''),
                          yesString: ATStrings.UNMUTE,
                          noString: ATStrings.cancel);
                      if (context.mounted && (shouldUnmute ?? false)) {
                        showAppNotification(
                            context: context,
                            icon: const Icon(Icons.check_circle),
                            text:
                                '${follower.obj.username} ${ATStrings.IS_UNMUTED}');
                      }
                    },
                  );
                }),
          );
        }),
      ),
    );
  }
}
