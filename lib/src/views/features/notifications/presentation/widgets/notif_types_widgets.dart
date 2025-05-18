import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/overlapping_images.dart';
import 'package:amptive/src/views/widgets/common_widgets/rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/common_widgets/circular_image.dart';

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
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ATCircularImage(
                diameter: 40,
                imagePath: follower.obj.profilePicture ?? ''
              ),
              Positioned(
                right: -4, top: -2,
                child: ATCircleAvatar(
                  padding: const EdgeInsets.all(3),
                  diameter: 20, color: ATColors.hex307FE2,
                  child: const Icon(Icons.person_add_alt_sharp),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                follower.obj.username ?? '': Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.JUST_FOLLOWED_U}. $timeOfFollow ${ATStrings.AGO}'.toLowerCase()
                  : Theme.of(context).textTheme.titleSmall!
              }
            ),
          ),
          const SizedBox(width: 15,),
          ATContainer(
            onTap: (){debugPrint('Hello');},
            radius: 20, padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            color: ATColors.hex307FE2,
            child: Text(
              '${ATStrings.FOLLOW} ${ATStrings.BACK}'.capitalize,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ]
      ),
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
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ATCircularImage(
                imagePath: subscriber.obj.profilePicture ?? '',
                diameter: 40,
              ),
              Positioned(
                right: -2, top: -2,
                child: ATCircleAvatar(
                  diameter: 20, color: ATColors.yellowColor,
                  child: Icon(Icons.favorite, color: ATColors.black, size: 15,),
                ),
              )
            ],
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                subscriber.obj.username ?? '': Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.JUST_SUBSCRIBED}. $timeOfSub ${ATStrings.AGO}'.toLowerCase()
                  : Theme.of(context).textTheme.titleSmall!
              }
            ),
          ),
        ]
      ),
    );
  }
}


class NewAttendeesNotif extends StatelessWidget {
  const NewAttendeesNotif({
    super.key,
    required this.attendees,
    required this.time,
    required this.progName,
    this.isEvent = false
  });
  final List<ObjectWithNotifier<Host>> attendees;
  final String time, progName; final bool isEvent;

  @override
  Widget build(BuildContext context) {
    String firstName = attendees.first.obj.username ?? '';
    final oneAttendee = attendees.length == 1;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          if(oneAttendee)ATCircularImage(
            diameter: 40,
            imagePath: attendees.first.obj.profilePicture ?? ''
          ) else ATOverlappingImages(
            overlapOffset: 7, imgSize: 25,
            imgPaths: attendees.map((attendee) => attendee.obj.profilePicture ?? '')
              .take(3).toList(),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                firstName: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                if(!oneAttendee)' and ' : Theme.of(context).textTheme.titleSmall!,
                if(!oneAttendee)'${attendees.length - 1} others ': Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                '${ATStrings.WILL_B_GOING_2_UR} ${isEvent ? ATStrings.EVENT : ATStrings.SHOW}: '
                  : Theme.of(context).textTheme.titleSmall!,
                progName: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                '. $time ${ATStrings.AGO}' : Theme.of(context).textTheme.titleSmall!,
              }
            ),
          ),
        ]
      ),
    );
  }
}



class NewGiftersNotif extends StatelessWidget {
  const NewGiftersNotif({
    super.key,
    required this.gifters,
    required this.time,
    required this.progName,
    this.isEvent = false
  });
  final List<ObjectWithNotifier<Host>> gifters;
  final String time, progName; final bool isEvent;

  @override
  Widget build(BuildContext context) {
    String firstName = gifters.first.obj.username ?? '';
    final oneGifter = gifters.length == 1;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          if(oneGifter)ATCircularImage(
            diameter: 40,
            imagePath: gifters.first.obj.profilePicture ?? ''
          ) else ATOverlappingImages(
            overlapOffset: 7, imgSize: 25,
            imgPaths: gifters.map((gifter) => gifter.obj.profilePicture ?? '')
              .take(3).toList(),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                firstName: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                if(!oneGifter)' and ' : Theme.of(context).textTheme.titleSmall!,
                if(!oneGifter)'${gifters.length - 1} others ': Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                '${ATStrings.SENT_U_A_GITF_DURING_LIVE} ${isEvent ? ATStrings.EVENT : ATStrings.SHOW}: '
                  : Theme.of(context).textTheme.titleSmall!,
                progName: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                '. $time ${ATStrings.AGO}' : Theme.of(context).textTheme.titleSmall!,
              }
            ),
          ),
        ]
      ),
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
      child: Row(
        children: [
          ATCircularImage(
            diameter: 40,
            imagePath: cohost.obj.profilePicture ?? ''
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                cohost.obj.name ?? '': Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.DECLINED_UR_COHOST_REQUEST}. $timeOfDecline ${ATStrings.AGO}'.toLowerCase()
                  : Theme.of(context).textTheme.titleSmall!
              }
            ),
          ),
        ]
      ),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: ATImgLoader(
              imgPath: progImg, boxFit: BoxFit.cover,
              height: 40, width: 40,
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                '${ATStrings.D_EVENT}: ' : Theme.of(context).textTheme.titleSmall!,
                progName : Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.HAS_BEEN_RESCHEDULED}. $timeOfReschedule ${ATStrings.AGO}'.toLowerCase() 
                  : Theme.of(context).textTheme.titleSmall!,
              }
            ),
          ),
          const SizedBox(width: 15,),
          ATContainer(
            onTap: (){debugPrint('Hello');},
            radius: 20, padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            color: ATColors.hex307FE2,
            child: Text(
              '${ATStrings.VIEW} ${ATStrings.DETAILS}'.capitalize,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ]
      ),
    );
  }
}


class ProgramEndedNotif extends StatelessWidget {
  const ProgramEndedNotif({
    super.key,
    required this.progName,
    required this.progImg,
    required this.timeOfEnd,
  });
  final String progName, timeOfEnd, progImg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: ATImgLoader(
              imgPath: progImg, boxFit: BoxFit.cover,
              height: 40, width: 40,
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                progName : Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.HAS_ENDED}. $timeOfEnd ${ATStrings.AGO}'.toLowerCase()
                : Theme.of(context).textTheme.titleSmall!,
              }
            ),
          ),
        ]
      ),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: ATImgLoader(
              imgPath: progImg, boxFit: BoxFit.cover,
              height: 40, width: 40,
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                '${isEvent ? ATStrings.D_EVENT : ATStrings.D_SHOW}: ': Theme.of(context).textTheme.titleSmall!,
                progName : Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.IS_LIVE}. $startTime ${ATStrings.AGO}' : Theme.of(context).textTheme.titleSmall!,
              }
            ),
          ),
          const SizedBox(width: 20,),
          ATCircleAvatar(diameter: 10, color: ATColors.textRedColor,)
        ]
      ),
    );
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: ATImgLoader(
              imgPath: progImg, boxFit: BoxFit.cover,
              height: 40, width: 40,
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                progName : Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.STARTS_IN} $startTime. $notifTime ${ATStrings.AGO}'
                  : Theme.of(context).textTheme.titleSmall!,
              }
            ),
          ),
        ]
      ),
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
      child: Row(
        children: [
          ATCircularImage(
            diameter: 40,
            imagePath: progOwner.obj.profilePicture ?? '',
          ),
          const SizedBox(width: 10,),

          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                progOwner.obj.username ?? '' : Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.INVITED_U_2_COHOST_IN_THE} ${isEvent ? ATStrings.EVENT : ATStrings.SHOW} ' 
                  : Theme.of(context).textTheme.titleSmall!,
                progName : Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                '. $inviteTime ${ATStrings.AGO}' : Theme.of(context).textTheme.titleSmall!,
              }
            ),
          ),
          const SizedBox(width: 15,),
          ATContainer(
            onTap: onResponse,
            radius: 20, padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            color: ATColors.hex307FE2,
            child: Text(
              ATStrings.RESPOND,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ]
      ),
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
      child: Row(
        children: [
          ATCircularImage(
            diameter: 40,
            imagePath: progImg,
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                '${ATStrings.U_R_PAID_2_COHOST_A_LIVE} ${isEvent ? ATStrings.EVENT : ATStrings.SHOW} ' 
                  : Theme.of(context).textTheme.titleSmall!,
                progName : Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' $inviteTime ${ATStrings.AGO}' : Theme.of(context).textTheme.titleSmall!,
              }
            ),
          ),
        ]
      ),
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
      onTap: () => context.pushNamed(ATRoutes.WALLET_TXNS),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          ATCircleAvatar(
            diameter: 40,
            color: ATColors.hex307FE2,
            child: const Icon(CupertinoIcons.arrow_up),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                ATStrings.UR_WITHDRAWAL_REQUEST : Theme.of(context).textTheme.titleSmall!,
                ' N$amount': Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.HAS_BEEN_PROCESSED}. $time': Theme.of(context).textTheme.titleSmall!
              }
            ),
          ),
        ]
      ),
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
      onTap: () => context.pushNamed(ATRoutes.WALLET_TXNS),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          ATCircleAvatar(
            diameter: 40,
            color: ATColors.hex307FE2,
            child: const Icon(CupertinoIcons.arrow_down),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                ATStrings.UR_DEPOSIT : Theme.of(context).textTheme.titleSmall!,
                ' N$amount': Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.WAS_SUCCESSFUL}. $time': Theme.of(context).textTheme.titleSmall!
              }
            ),
          ),
        ]
      ),
    );
  }
}



class MoneyReceivedNotif extends StatelessWidget {
  const MoneyReceivedNotif({
    super.key,
    required this.amount,
    required this.time,
    required this.senderName
  });
  final String amount, time, senderName;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: () => context.pushNamed(ATRoutes.WALLET_TXNS),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          ATCircleAvatar(
            diameter: 40,
            color: ATColors.hex307FE2,
            child: const Icon(CupertinoIcons.arrow_down),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ATRichText(
              maxLines: 2,
              items: {
                '$senderName sent' : Theme.of(context).textTheme.titleSmall!,
                ' N$amount': Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ATFontSizes.size13
                ),
                ' ${ATStrings.TO_UR_WALLET}. $time': Theme.of(context).textTheme.titleSmall!
              }
            ),
          ),
        ]
      ),
    );
  }
}