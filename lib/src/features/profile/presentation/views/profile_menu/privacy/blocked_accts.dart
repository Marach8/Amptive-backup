import 'package:amptive/src/bloc/main_app/profile/profile_followers_bloc.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../utils/dialogs/app_notification_dialog.dart';

class AmptiveBlockedAcctsScreen extends StatelessWidget {
  const AmptiveBlockedAcctsScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 0),
              child: Row(
                children: [
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
              builder: (_, state) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 50),
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.length,
                    itemBuilder: (_, listIndex){
                      final subscriber = state.elementAt(listIndex);
                      return AmptiveBlockedOrMutedAcctWidget(
                        subscriber: subscriber,
                        text: ATStrings.UNBLOCK,
                        onTap: (follower, isSelected) async{
                          final shouldUnblock = await showConfirmationDialog(
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
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> subscriber;
  final String text;

  const AmptiveBlockedOrMutedAcctWidget({
    super.key,
    required this.onTap,
    required this.subscriber,
    required this.text
  });

  @override
  Widget build(context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
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
                fontSize: ATFontSizes.size13,
              ),
            ),
          )
        ],
      ),
    );
  }
}
