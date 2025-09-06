import 'package:amptive/src/bloc/main_app/profile/profile_followers_bloc.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../config/utils/dialogs/app_notification_dialog.dart';

class AmptiveBlockedAcctsScreen extends StatelessWidget {
  const AmptiveBlockedAcctsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 0),
              child: Row(
                children: <Widget>[
                  ATCircleAvatar(
                    onTap: () => context.pop(),
                    diameter: 30, color: ATColors.trsprnt,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const Spacer(),
                  Text(
                    ATStrings.BLOCKED_ACCTS,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_left, color: ATColors.trsprnt),
                ],
              ),
            ),

            BlocBuilder<AmptiveProfileFollowersBloc, List<ObjectWithNotifier<Host>>>(
              builder: (_, List<ObjectWithNotifier<Host>> state) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 50),
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.length,
                    itemBuilder: (_, int listIndex){
                      final ObjectWithNotifier<Host> subscriber = state.elementAt(listIndex);
                      return AmptiveBlockedOrMutedAcctWidget(
                        subscriber: subscriber,
                        text: ATStrings.UNBLOCK,
                        onTap: (ObjectWithNotifier<Host> follower, bool isSelected) async{
                          final bool? shouldUnblock = await showConfirmationDialog(
                            context: context,
                            title: '${ATStrings.UNBLOCK} ${follower.obj.username}',
                            content: '${follower.obj.username} ${ATStrings.UNBLOCK_DESC}',
                            yesString: ATStrings.UNBLOCK,
                            noString: ATStrings.CANCEL
                          );
                          if(context.mounted && (shouldUnblock ?? false)){
                            showAppNotification(
                              context: context,
                              icon: const Icon(Icons.check_circle),
                              text: '${follower.obj.username} ${ATStrings.IS_UNBLOCKED}'
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




class AmptiveBlockedOrMutedAcctWidget extends StatelessWidget {

  const AmptiveBlockedOrMutedAcctWidget({
    super.key,
    required this.onTap,
    required this.subscriber,
    required this.text
  });
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> subscriber;
  final String text;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          ATContainer(
            clipBehavior: Clip.hardEdge,
            height: 50, width: 50, radius: 30,
            child: FittedBox(
              fit: BoxFit.fill,
              child: ATImgLoader(imgPath: subscriber.obj.profilePicture!)
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              subscriber.obj.username ?? '',
              style: Theme.of(context).textTheme.titleMedium
            ),
          ),
          ATContainer(
            onTap: () => onTap(subscriber, subscriber.notifier.value),
            border: Border.all(color: ATColors.white),
            radius: 30, 
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: ATSizes.size13,
              ),
            ),
          )
        ],
      ),
    );
  }
}
