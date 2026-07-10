import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/features/dashboard.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/extensions/context_extensions.dart';

class PaidShowAndPlayBtnWidget extends StatelessWidget {
  const PaidShowAndPlayBtnWidget({
    super.key,
    this.icon,
    this.homeFeedItem,
  });
  final IconData? icon;
  final HomeFeedItem? homeFeedItem;

  @override
  Widget build(BuildContext context) {
    final bool isLive = homeFeedItem?.programStatus == ProgramStatus.live;
    final String programCategory = getProgramLabel(
      type: homeFeedItem?.programType,
      category: homeFeedItem?.programCategory,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.5),
          margin: const EdgeInsets.only(top: 18),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ATColors.hex0D0D0D),
          child: Text(
            programCategory,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 10
            )
          ),
        ),

        if(isLive)GestureDetector(
          onTap: ()async{
            final bool isEvent = homeFeedItem?.programCategory
              == ProgramCategory.standalone;

            LiveProgramData? liveProgramData;
            if(isEvent){
              liveProgramData = await context.pushNamed(
                ATRoutes.liveEventDetailedScreen,
                extra: homeFeedItem,
              ) as LiveProgramData?;
            }
            else{
              liveProgramData = await context.pushNamed(
                ATRoutes.liveShowDetailedScreen,
                extra: homeFeedItem,
              ) as LiveProgramData?;
            }

            if (liveProgramData == null) return;
            dashboardKey.currentState
              ?.showLiveStreamOverlay(liveProgramData: liveProgramData);
          },
          child: CircleAvatar(
            radius: 22.5,
            backgroundColor: ATColors.hexB6B6B6,
            child: Icon(icon ?? Icons.play_arrow,
              color: ATColors.hex0D0D0D, size: 30),
          ),
        )
      ],
    );
  }
}


String getProgramLabel({
  required ProgramType? type,
  required ProgramCategory? category,
}) {
  return switch ((category, type)) {
    (ProgramCategory.episode, ProgramType.free) => 'SHOW',
    (ProgramCategory.episode, ProgramType.paid) => '\$PAID SHOW',
    (ProgramCategory.standalone, ProgramType.free) => 'EVENT',
    (ProgramCategory.standalone, ProgramType.paid) => '\$PAID EVENT',
    _ => ''
  };
}
