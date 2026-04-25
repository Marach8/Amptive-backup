import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/shared/rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/circular_image.dart';

class NewFollowerNotif extends StatelessWidget {
  const NewFollowerNotif({
    super.key,
    required this.follower,
    required this.timeOfFollow,
  });
  final ObjectWithNotifier<Host> follower;
  final String timeOfFollow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            ATCircularImage(
                diameter: 40, imagePath: follower.obj.profilePicture ?? ''),
            Positioned(
              right: -4,
              top: -2,
              child: ATCircleAvatar(
                padding: const EdgeInsets.all(3),
                diameter: 20,
                color: ATColors.hex307FE2,
                child: const Icon(Icons.person_add_alt_sharp),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            follower.obj.username ?? '': Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.JUST_FOLLOWED_U}. $timeOfFollow ${ATStrings.AGO}'
                .toLowerCase(): Theme.of(context).textTheme.titleSmall!
          }),
        ),
        const SizedBox(
          width: 15,
        ),
        ATContainer(
          onTap: () {
            debugPrint('Hello');
          },
          radius: 20,
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          color: ATColors.hex307FE2,
          child: Text(
            '${ATStrings.FOLLOW} ${ATStrings.BACK}'.capitalize,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
      ]),
    );
  }
}

class NewSubscriberNotif extends StatelessWidget {
  const NewSubscriberNotif({
    super.key,
    required this.subscriber,
    required this.timeOfSub,
  });
  final ObjectWithNotifier<Host> subscriber;
  final String timeOfSub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            ATCircularImage(
              imagePath: subscriber.obj.profilePicture ?? '',
              diameter: 40,
            ),
            Positioned(
              right: -2,
              top: -2,
              child: ATCircleAvatar(
                diameter: 20,
                color: ATColors.yellowColor,
                child: Icon(
                  Icons.favorite,
                  color: ATColors.black,
                  size: 15,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            subscriber.obj.username ?? '': Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.JUST_SUBSCRIBED}. $timeOfSub ${ATStrings.AGO}'
                .toLowerCase(): Theme.of(context).textTheme.titleSmall!
          }),
        ),
      ]),
    );
  }
}

class NewAttendeesNotif extends StatelessWidget {
  const NewAttendeesNotif(
      {super.key,
      required this.attendees,
      required this.time,
      required this.progName,
      this.isEvent = false});
  final List<ObjectWithNotifier<Host>> attendees;
  final String time, progName;
  final bool isEvent;

  @override
  Widget build(BuildContext context) {
    String firstName = attendees.first.obj.username ?? '';
    final bool oneAttendee = attendees.length == 1;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        if (oneAttendee)
          ATCircularImage(
              diameter: 40, imagePath: attendees.first.obj.profilePicture ?? '')
        else
          ATOverlappingImages(
            overlapOffset: 7,
            imgSize: 25,
            imgPaths: attendees
                .map((ObjectWithNotifier<Host> attendee) =>
                    attendee.obj.profilePicture ?? '')
                .take(3)
                .toList(),
          ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            firstName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            if (!oneAttendee) ' and ': Theme.of(context).textTheme.titleSmall!,
            if (!oneAttendee)
              '${attendees.length - 1} others ': Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: ATSizes.size13),
            '${ATStrings.WILL_B_GOING_2_UR} ${isEvent ? ATStrings.event : ATStrings.SHOW}: ':
                Theme.of(context).textTheme.titleSmall!,
            progName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            '. $time ${ATStrings.AGO}': Theme.of(context).textTheme.titleSmall!,
          }),
        ),
      ]),
    );
  }
}

class NewGiftersNotif extends StatelessWidget {
  const NewGiftersNotif(
      {super.key,
      required this.gifters,
      required this.time,
      required this.progName,
      this.isEvent = false});
  final List<ObjectWithNotifier<Host>> gifters;
  final String time, progName;
  final bool isEvent;

  @override
  Widget build(BuildContext context) {
    String firstName = gifters.first.obj.username ?? '';
    final bool oneGifter = gifters.length == 1;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        if (oneGifter)
          ATCircularImage(
              diameter: 40, imagePath: gifters.first.obj.profilePicture ?? '')
        else
          ATOverlappingImages(
            overlapOffset: 7,
            imgSize: 25,
            imgPaths: gifters
                .map((ObjectWithNotifier<Host> gifter) =>
                    gifter.obj.profilePicture ?? '')
                .take(3)
                .toList(),
          ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            firstName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            if (!oneGifter) ' and ': Theme.of(context).textTheme.titleSmall!,
            if (!oneGifter)
              '${gifters.length - 1} others ': Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: ATSizes.size13),
            '${ATStrings.SENT_U_A_GITF_DURING_LIVE} ${isEvent ? ATStrings.event : ATStrings.SHOW}: ':
                Theme.of(context).textTheme.titleSmall!,
            progName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            '. $time ${ATStrings.AGO}': Theme.of(context).textTheme.titleSmall!,
          }),
        ),
      ]),
    );
  }
}

class DeclinedCohostInviteNotif extends StatelessWidget {
  const DeclinedCohostInviteNotif({
    super.key,
    required this.cohost,
    required this.timeOfDecline,
  });
  final ObjectWithNotifier<Host> cohost;
  final String timeOfDecline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ATCircularImage(
            diameter: 40, imagePath: cohost.obj.profilePicture ?? ''),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            cohost.obj.name ?? '': Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.DECLINED_UR_COHOST_REQUEST}. $timeOfDecline ${ATStrings.AGO}'
                .toLowerCase(): Theme.of(context).textTheme.titleSmall!
          }),
        ),
      ]),
    );
  }
}

class ProgramRescheduledNotif extends StatelessWidget {
  const ProgramRescheduledNotif({
    super.key,
    required this.progName,
    required this.progImg,
    required this.timeOfReschedule,
  });
  final String progName, timeOfReschedule, progImg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: ATImgLoader(
            imgPath: progImg,
            boxFit: BoxFit.cover,
            height: 40,
            width: 40,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            '${ATStrings.D_EVENT}: ': Theme.of(context).textTheme.titleSmall!,
            progName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.HAS_BEEN_RESCHEDULED}. $timeOfReschedule ${ATStrings.AGO}'
                .toLowerCase(): Theme.of(context).textTheme.titleSmall!,
          }),
        ),
        const SizedBox(
          width: 15,
        ),
        ATContainer(
          onTap: () {
            debugPrint('Hello');
          },
          radius: 20,
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          color: ATColors.hex307FE2,
          child: Text(
            '${ATStrings.VIEW} ${ATStrings.DETAILS}'.capitalize,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
      ]),
    );
  }
}

class ProgramEndedNotif extends StatelessWidget {
  const ProgramEndedNotif({
    super.key,
    required this.progName,
    required this.progImg,
    required this.timeOfEnd,
    this.ontap
  });
  final String progName, timeOfEnd, progImg;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: ATImgLoader(
            imgPath: progImg,
            boxFit: BoxFit.cover,
            height: 40,
            width: 40,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 3, items: <String, TextStyle>{
            progName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' $timeOfEnd ${ATStrings.AGO}'
                .toLowerCase(): Theme.of(context).textTheme.titleSmall!,
          }),
        ),
      ]),
    );
  }
}

class ProgramIsLiveNotif extends StatelessWidget {
  const ProgramIsLiveNotif({
    super.key,
    required this.progName,
    required this.progImg,
    required this.startTime,
    this.isEvent = true,
  });
  final String progName, startTime, progImg;
  final bool isEvent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: ATImgLoader(
            imgPath: progImg,
            boxFit: BoxFit.cover,
            height: 40,
            width: 40,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            '${isEvent ? ATStrings.D_EVENT : ATStrings.D_SHOW}: ':
                Theme.of(context).textTheme.titleSmall!,
            progName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.IS_LIVE}. $startTime ${ATStrings.AGO}':
                Theme.of(context).textTheme.titleSmall!,
          }),
        ),
        const SizedBox(
          width: 20,
        ),
        const _LiveProgramIndicator()
      ]),
    );
  }
}

class _LiveProgramIndicator extends StatefulWidget {
  const _LiveProgramIndicator();

  @override
  State<_LiveProgramIndicator> createState() => _LiveProgramIndicatorState();
}

class _LiveProgramIndicatorState extends State<_LiveProgramIndicator> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: Tween<double>(begin: isDone ? 3 : 10, end: isDone ? 10 : 3),
        onEnd: () => setState(() => isDone = !isDone),
        builder: (_, double size, __) {
          return ATCircleAvatar(
            diameter: size,
            color: ATColors.textRedColor,
          );
        });
  }
}

class ProgramAbout2StartNotif extends StatelessWidget {
  const ProgramAbout2StartNotif({
    super.key,
    required this.progName,
    required this.progImg,
    required this.startTime,
    required this.notifTime,
  });
  final String progName, startTime, progImg, notifTime;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: ATImgLoader(
            imgPath: progImg,
            boxFit: BoxFit.cover,
            height: 40,
            width: 40,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            progName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.STARTS_IN} $startTime. $notifTime ${ATStrings.AGO}':
                Theme.of(context).textTheme.titleSmall!,
          }),
        ),
      ]),
    );
  }
}

class CohostInviteNotif extends StatelessWidget {
  const CohostInviteNotif({
    super.key,
    required this.progName,
    required this.inviteTime,
    required this.progOwner,
    required this.onResponse,
    this.isEvent = true,
  });
  final String progName, inviteTime;
  final bool isEvent;
  final ObjectWithNotifier<Host> progOwner;
  final VoidCallback onResponse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ATCircularImage(
          diameter: 40,
          imagePath: progOwner.obj.profilePicture ?? '',
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            progOwner.obj.username ?? '': Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.INVITED_U_2_COHOST_IN_THE} ${isEvent ? ATStrings.event : ATStrings.SHOW} ':
                Theme.of(context).textTheme.titleSmall!,
            progName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            '. $inviteTime ${ATStrings.AGO}':
                Theme.of(context).textTheme.titleSmall!,
          }),
        ),
        const SizedBox(
          width: 15,
        ),
        ATContainer(
          onTap: onResponse,
          radius: 20,
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          color: ATColors.hex307FE2,
          child: Text(
            ATStrings.RESPOND,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
      ]),
    );
  }
}

class CohostInvitePaymentNotif extends StatelessWidget {
  const CohostInvitePaymentNotif({
    super.key,
    required this.progName,
    required this.progImg,
    required this.inviteTime,
    this.isEvent = true,
  });
  final String progName, inviteTime, progImg;
  final bool isEvent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ATCircularImage(
          diameter: 40,
          imagePath: progImg,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            '${ATStrings.U_R_PAID_2_COHOST_A_LIVE} ${isEvent ? ATStrings.event : ATStrings.SHOW} ':
                Theme.of(context).textTheme.titleSmall!,
            progName: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' $inviteTime ${ATStrings.AGO}':
                Theme.of(context).textTheme.titleSmall!,
          }),
        ),
      ]),
    );
  }
}

class WithdrawalProcessedNotif extends StatelessWidget {
  const WithdrawalProcessedNotif({
    super.key,
    required this.amount,
    required this.time,
  });
  final String amount, time;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: () => context.pushNamed(ATRoutes.walletTransactionsHistoryScreen),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ATCircleAvatar(
          diameter: 40,
          color: ATColors.hex307FE2,
          child: const Icon(CupertinoIcons.arrow_up),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            ATStrings.UR_WITHDRAWAL_REQUEST:
                Theme.of(context).textTheme.titleSmall!,
            ' N$amount': Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.HAS_BEEN_PROCESSED}. $time':
                Theme.of(context).textTheme.titleSmall!
          }),
        ),
      ]),
    );
  }
}

class DepositSuccessNotif extends StatelessWidget {
  const DepositSuccessNotif({
    super.key,
    required this.amount,
    required this.time,
  });
  final String amount, time;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: () => context.pushNamed(ATRoutes.walletTransactionsHistoryScreen),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ATCircleAvatar(
          diameter: 40,
          color: ATColors.hex307FE2,
          child: const Icon(CupertinoIcons.arrow_down),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            ATStrings.UR_DEPOSIT: Theme.of(context).textTheme.titleSmall!,
            ' N$amount': Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.WAS_SUCCESSFUL}. $time':
                Theme.of(context).textTheme.titleSmall!
          }),
        ),
      ]),
    );
  }
}

class MoneyReceivedNotif extends StatelessWidget {
  const MoneyReceivedNotif(
      {super.key,
      required this.amount,
      required this.time,
      required this.senderName});
  final String amount, time, senderName;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: () => context.pushNamed(ATRoutes.walletTransactionsHistoryScreen),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: <Widget>[
        ATCircleAvatar(
          diameter: 40,
          color: ATColors.hex307FE2,
          child: const Icon(CupertinoIcons.arrow_down),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ATRichText(maxLines: 2, items: <String, TextStyle>{
            '$senderName sent': Theme.of(context).textTheme.titleSmall!,
            ' N$amount': Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: ATSizes.size13),
            ' ${ATStrings.TO_UR_WALLET}. $time':
                Theme.of(context).textTheme.titleSmall!
          }),
        ),
      ]),
    );
  }
}

class GenericAppNotificationTile extends StatelessWidget {
  const GenericAppNotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.time,
    required this.isRead,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? time;
  final bool isRead;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          ATCircleAvatar(
            diameter: 40,
            color: ATColors.hex307FE2,
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 22,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ATRichText(
              maxLines: 3,
              items: <String, TextStyle>{
                '$title: ': Theme.of(context).textTheme.titleSmall!,
                subtitle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: ATSizes.size13),
                '. $time': Theme.of(context).textTheme.titleSmall!,
              },
            ),
          ),
        ],
      ),
    );
  }
}
