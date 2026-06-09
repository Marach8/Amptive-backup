import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/listeners_modal.dart';
import 'package:amptive/src/shared/confirmation_alert_dialog.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/utils/extensions/context_extensions.dart';

class InvitedCohostsTab extends StatelessWidget {
  const InvitedCohostsTab({
    super.key,
    required this.invitedCohosts
  });
  final List<User> invitedCohosts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: invitedCohosts.map(
        (User? cohost){
          return _CohostTile(cohost: cohost);
        }
      ).toList(),
    );
  }
}


class AcceptedCohostsTab extends StatelessWidget {
  const AcceptedCohostsTab({
    super.key,
    required this.acceptedCohosts
  });
  final List<User> acceptedCohosts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: acceptedCohosts.map(
        (User? cohost){
          return _CohostTile(cohost: cohost);
        }
      ).toList(),
    );
  }
}


class DeclinedCohostsTab extends StatelessWidget {
  const DeclinedCohostsTab({
    super.key,
    required this.declinedCohosts
  });
  final List<User> declinedCohosts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: declinedCohosts.map(
        (User? cohost){
          return _CohostTile(cohost: cohost);
        }
      ).toList(),
    );
  }
}


class IgnoredCohostsTab extends StatelessWidget {
  const IgnoredCohostsTab({
    super.key,
    required this.ignoredCohosts
  });
  final List<User> ignoredCohosts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ignoredCohosts.map(
        (User? cohost){
          return _CohostTile(cohost: cohost);
        }
      ).toList(),
    );
  }
}



class _CohostTile extends StatelessWidget {
  const _CohostTile({
    required this.cohost,
  });

  final User? cohost;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: ATImgLoader(
              imgPath: cohost?.profilePicture ?? '',
              height: 46.4,
              width: 46.4,
              boxFit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              cohost?.username ?? '',
              style: context.textTheme.titleMedium,
            ),
          ),
          //if (isHost) const HostIndicator() 
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 8,
              children: <Widget>[
                MuteUmuteListenerBtn(
                  participantId: cohost?.userId?? ''),
                ATContainer(
                  onTap: () async {
                    final bool? shouldKickOut = await showKickOutConfirmationDialog(
                      context: context,
                      title: 'Are you kicking out ${cohost?.username}?',
                      content: '${cohost?.username} will be unable to join this current live program but can join your future live sessions',
                      listenerPic: cohost?.profilePicture ?? ATImgStrings.jpeg1,
                    );
                    if(context.mounted && shouldKickOut == true){
                      context.read<LiveStreamCubit1>()
                        .kickOutListener(cohost?.userId?? '');
                    }
                  },
                  height: 35, width: 35, radius: 20,
                  color: ATColors.white.withValues(alpha: 0.1),
                  child: const ATImgLoader(
                    boxFit: BoxFit.scaleDown,
                    imgPath: ATImgStrings.kickUserOut,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
