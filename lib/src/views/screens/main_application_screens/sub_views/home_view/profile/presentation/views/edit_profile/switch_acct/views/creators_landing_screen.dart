import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../bloc/profile_bloc_export.dart';

class CreatorLandingScreen extends StatelessWidget {
  const CreatorLandingScreen({super.key});

  @override
  Widget build(context) {
    final lists = <List<String>>[
      [ATImgStrings.CREATOR_MIC, ATStrings.CREATE_LIVE_SHOWS_ND_EVENTS, ATStrings.HOST_CAPTIVATING_PROGRAMS],
      [ATImgStrings.CREATOR_GIF, ATStrings.RECEIVE_GIFTS_4RM_AUDIENCE, ATStrings.GET_SUPPORT_4RM_FANS],
      [ATImgStrings.CREATOR_GLOBE, ATStrings.EARN_BY_COMPLETING_TASKS, ATStrings.TAKE_TASK_ND_GET_REWARDS],
      [ATImgStrings.CREATOR_LOCK, ATStrings.ENABLE_SUB_4_UR_SHOW, ATStrings.OFFER_XCLUSIVE_CONTENT]
    ];

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        const Duration(milliseconds: 500),
        () => context.mounted ? context.read<CreatorLandingAnimationBloc>().triggerNext(0) : {}
      )
    );
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leadingWidth: 30,
          padding: EdgeInsets.only(left: 7),
          leading: ATXBackBtn(),
        ),
      
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
            child: Column(
              children: [
                const ATImgLoader(
                  imgPath: ATImgStrings.CREATOR_ACCT_LOGO,
                  height: 70, width: 80
                ),
                const SizedBox(height: 40),
                Text(
                  ATStrings.AMPTIVE_4_CREATORS,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: ATFontSizes.size24
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  ATStrings.U_OWN_STAGE,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATFontSizes.size13,
                    color: ATColors.hexC2C2C2
                  ),
                ),
                const SizedBox(height: 20,),
                
                ...lists.asMap().entries.map(
                  (entry){
                    final index = entry.key;
                    final eachList = entry.value;
                    return _CustomWidget(
                      imgPath: eachList.first,
                      subTitle: eachList.last,
                      title: eachList[1],
                      index: index,
                    );
                  }
                )
              ],
            )
          ),
        ),
      
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: BlocSelector<CreatorLandingAnimationBloc, List<bool>, bool>(
            selector: (state) => state.last,
            builder: (_, isVisible) {
              return ATPlainElevatedBtn(
                onPressed: isVisible ? () => context.pushNamed(ATRoutes.SELECT_CAT) : null,
                btnTitle: ATStrings.PROCEED,
              );
            }
          )
        ),
      ),
    );
  }
}

class _CustomWidget extends StatelessWidget {
  const _CustomWidget({
    required this.imgPath,
    required this.subTitle,
    required this.title,
    required this.index
  });
  final String imgPath, title, subTitle;
  final int index;

  @override
  Widget build(context) {
    return BlocSelector<CreatorLandingAnimationBloc, List<bool>, bool>(
      selector: (state) => state.elementAt(index),
      builder: (_, isVisible) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isVisible ? 1 : 0, curve: Curves.decelerate,
          onEnd: () => isVisible? context.read<CreatorLandingAnimationBloc>().triggerNext(index + 1): null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                ATImgLoader(imgPath: imgPath),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: ATFontSizes.size15
                        ),
                      ),
                      Text(
                        subTitle, maxLines: 3,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: ATFontSizes.size13,
                          color: ATColors.hexC2C2C2
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}