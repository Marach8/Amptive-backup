import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/spotlight_beam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../bloc/profile_bloc_export.dart';


class SelectedAcctLandingScreen extends StatelessWidget {
  const SelectedAcctLandingScreen({super.key});

  static const List<List<String>> creatorList = <List<String>>[
    <String>[ATImgStrings.CREATOR_MIC, ATStrings.CREATE_LIVE_SHOWS_ND_EVENTS, ATStrings.HOST_CAPTIVATING_PROGRAMS],
    <String>[ATImgStrings.CREATOR_GIF, ATStrings.RECEIVE_GIFTS_4RM_AUDIENCE, ATStrings.GET_SUPPORT_4RM_FANS],
    <String>[ATImgStrings.CREATOR_GLOBE, ATStrings.EARN_BY_COMPLETING_TASKS, ATStrings.TAKE_TASK_ND_GET_REWARDS],
    <String>[ATImgStrings.CREATOR_LOCK, ATStrings.ENABLE_SUB_4_UR_SHOW, ATStrings.OFFER_XCLUSIVE_CONTENT]
  ];

  static const List<List<String>> businessList = <List<String>>[
    <String>[ATImgStrings.BIZ_THUNDER, ATStrings.PARTNER_WITH_CREATORS, ATStrings.COLLABORATE_WITH_CREATORS],
    <String>[ATImgStrings.BIZ_TICKETS, ATStrings.SELL_TICKETS, ATStrings.MONETIZE_EVENTS],
    <String>[ATImgStrings.CREATOR_MIC, ATStrings.HOST_BRANDED_AUDIO, ATStrings.ENGAGE_AUDIENCE],
    <String>[ATImgStrings.BIZ_ARROW, ATStrings.PROMOTE_UR_BUSINESS, ATStrings.SHOWCASE_UR_PRODUCTS]
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        const Duration(milliseconds: 500),
        () => context.mounted ? context.read<AcctTypeLandingAnimBloc>().triggerNext(0) : <dynamic, dynamic>{}
      )
    );
    
    final bool isCreator = context.read<AccountTypeBloc>().state;

    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprnt,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: ATHelperFuncs.getScreenHeight(context) * 0.3,
                width: ATHelperFuncs.getScreenWidth(context),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    BlocSelector<AcctTypeLandingAnimBloc, List<bool>, bool>(
                      selector: (List<bool> state) => state.elementAt(0),
                      builder: (_, bool isVisible) {
                        return SpotlightBeam(
                          duration: 1500,
                          gradient: isVisible ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              ATColors.hex23221C,
                              ATColors.black
                            ],
                          ) : null,
                        );
                      }
                    ),
                    Positioned(
                      bottom: 0,
                      child: ATImgLoader(
                        imgPath: isCreator ? ATImgStrings.CREATOR_ACCT_LOGO : ATImgStrings.BIZ_ACCT_LOGO,
                        height: 70, width: 80
                      ),
                    ),
                    const Positioned(
                      top: kToolbarHeight * 0.9, left: 7,
                      child: ATXBackBtn()
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Text(
                  isCreator ? ATStrings.AMPTIVE_4_CREATORS : ATStrings.AMPTIVE_4_BIZ,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: ATSizes.size24
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Text(
                  isCreator ? ATStrings.U_OWN_STAGE : ATStrings.CONNECT_SELL,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATSizes.size13,
                    color: ATColors.hexC2C2C2
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              
              ...(isCreator ? creatorList : businessList).asMap().entries.map(
                (MapEntry<int, List<String>> entry){
                  final int index = entry.key;
                  final List<String> eachList = entry.value;
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
      
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: BlocSelector<AcctTypeLandingAnimBloc, List<bool>, bool>(
            selector: (List<bool> state) => state.last,
            builder: (_, bool isVisible) {
              return ATPlainElevatedBtn(
                onPressed: isVisible ? () => context.pushNamed(
                  ATRoutes.SELECT_CAT, extra: isCreator
                ) : null,
                btnTitle: ATStrings.CONTINUE
              );
            }
          )
        )
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
  Widget build(BuildContext context) {
    return BlocSelector<AcctTypeLandingAnimBloc, List<bool>, bool>(
      selector: (List<bool> state) => state.elementAt(index),
      builder: (_, bool isVisible) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isVisible ? 1 : 0, curve: Curves.decelerate,
          onEnd: () => isVisible? context.read<AcctTypeLandingAnimBloc>().triggerNext(index + 1): null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
            child: Row(
              children: <Widget>[
                ATImgLoader(imgPath: imgPath),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title, maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: ATSizes.size15
                        ),
                      ),
                      Text(
                        subTitle, maxLines: 3,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: ATSizes.size13,
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

