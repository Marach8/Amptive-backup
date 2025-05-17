import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/views/features/notifications/presentation/widgets/notif_widgets_export.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/search_filter_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/common_widgets/annotated_region__widget.dart';

class ATNotificationScreen extends StatelessWidget {
  const ATNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (_, __) => [
              const ATSliverAppBar(titleText: ATStrings.TXN_HISTORY,),
              SliverPersistentHeader(
                pinned: true,
                delegate: ATSliverHDelegate(
                  maxExt: 70, minExt: 70, 
                  child: Container(
                    height: 70,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                    child: ATTextFormField(
                      fillColor: ATColors.white.withValues(alpha: 0.1),
                      onChanged: (text){},
                    ),
                  )
                ),
              )
            ],

            body: ListView(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
              children: [
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
                  inviteTime: '54m',
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
        ),
      ),
    );
  }
}