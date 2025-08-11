import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/config/utils/dialogs/notification/view_cohost_invite.dart';
import 'package:amptive/src/features/main_app_shell.dart';
import 'package:amptive/src/features/notifications/presentation/widgets/notif_widgets_export.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../views/widgets/common_widgets/annotated_region__widget.dart';

class NotificationTabView extends StatelessWidget {
  const NotificationTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: context.read<ATNavBarBloc>().ctrlNavVisibility,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) => <Widget>[
          const ATSliverAppBar(
            titleText: ATStrings.TXN_HISTORY,
            leading: SizedBox.shrink(),
          ),
        ],
      
        body: ListView(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
          children: <Widget>[
            NewFollowerNotif(
              follower: getHostList().first,
              timeOfFollow: '20s',
            ),
            
            const ProgramRescheduledNotif(
              progName: 'Trump in Nigera',
              progImg: ATImgStrings.JOE_POMP_SHOW,
              timeOfReschedule: '1h'
            ),
            
            const ProgramEndedNotif(
              progName: 'We Can Do Hard Things',
              progImg: ATImgStrings.JOE_POMP_SHOW,
              timeOfEnd: '1m'
            ),
      
            const ProgramIsLiveNotif(
              progImg: ATImgStrings.jpeg1,
              progName: 'Sports Wednessday',
              startTime: '4h', isEvent: false,
            ),
      
            const ProgramIsLiveNotif(
              progImg: ATImgStrings.jpeg1,
              progName: 'Happier',
              startTime: '2m',
            ),
      
            DeclinedCohostInviteNotif(
              cohost: getHostList()[3],
              timeOfDecline: '5h',
            ),
      
            const CohostInvitePaymentNotif(
              progName: 'Football Weekly',
              progImg: ATImgStrings.jpeg3,
              inviteTime: '5h',
            ),
      
            const ProgramIsLiveNotif(
              progImg: ATImgStrings.jpeg1,
              progName: 'Nigerians in Diaspora',
              startTime: '4s',
            ),
      
            CohostInviteNotif(
              progOwner: getHostList()[6],
              progName: 'Sports Weekly',
              inviteTime: '54m', isEvent: false,
              onResponse: ()async{
                final (int?, bool)? result = await viewCoHostInviteDetails(
                  context: context, coHostFee: '5,000',
                  hostImg: getHostList()[6].obj.profilePicture ?? '',
                  progName: 'Sports Weekly',
                  hostUsername: getHostList()[6].obj.username ?? '',
                  isEvent: false,
                );
              },
            ),
      
            const ProgramAbout2StartNotif(
              notifTime: '10m',
              progImg: ATImgStrings.techCard,
              startTime: '1hour',
              progName: 'Talks With Jozy',
            ),
      
            NewSubscriberNotif(
              subscriber: getHostList()[2],
              timeOfSub: '56s',
            ),
      
            NewAttendeesNotif(
              attendees: getHostList().take(3).toList(),
              progName: 'Bitcoin Beach',
              isEvent: true, time: '23h',
            ),
      
            NewGiftersNotif(
              gifters: getHostList().reversed.take(3).toList(),
              progName: 'Trump Is Winning',
              time: '4s',
            ),
      
            NewAttendeesNotif(
              attendees: getHostList().take(1).toList(),
              progName: 'The Only Way',
              isEvent: true, time: '56m',
            ),
      
            const WithdrawalProcessedNotif(
              amount: '500,000',
              time: '26m',
            ),
      
            CohostInviteNotif(
              progOwner: getHostList()[9],
              progName: 'Nigerains In Diaspora',
              inviteTime: '5m',
              onResponse: ()async{
                final (int?, bool)? result = await viewCoHostInviteDetails(
                  context: context,
                  hostImg: getHostList()[9].obj.profilePicture ?? '',
                  progName: 'Nigerains In Diaspora',
                  hostUsername: getHostList()[9].obj.username ?? '',
                  isEvent: true,
                );
              },
            ),
      
            const DepositSuccessNotif(
              amount: '1,000,000',
              time: '35s',
            ),
      
            const MoneyReceivedNotif(
              amount: '55,050',
              time: '2h', senderName: 'nnanna',
            ),
          ],
        ),
      
        // body: ListView.builder(
        //   itemCount: 10,
        //   padding: const EdgeInsets.fromLTRB(15, 0, 15, 40),
        //   itemBuilder: (_, index){
        //     return Padding(
        //       padding: const EdgeInsets.only(bottom: 25),
        //       child: Column(
        //         spacing: 15,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           NewFollowerNotif(
        //             follower: getHostList().first,
        //             timeOfFollow: '20s',
        //           )
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}