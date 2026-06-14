import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/select_acct_type_screen.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/spotlight_beam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/bloc/profile_bloc_export.dart';

class SelectedAcctOnboardScreen extends StatelessWidget {
  const SelectedAcctOnboardScreen({super.key, required this.acctType});
  final UpgradeAcctType acctType;

  static const Map<UpgradeAcctType, List<List<String>>> onboardContent =
      <UpgradeAcctType, List<List<String>>>{
    UpgradeAcctType.creator: <List<String>>[
      <String>[
        ATImgStrings.CREATOR_MIC,
        ATStrings.CREATE_LIVE_SHOWS_ND_EVENTS,
        ATStrings.HOST_CAPTIVATING_PROGRAMS
      ],
      <String>[
        ATImgStrings.CREATOR_GIF,
        ATStrings.RECEIVE_GIFTS_4RM_AUDIENCE,
        ATStrings.GET_SUPPORT_4RM_FANS
      ],
      <String>[
        ATImgStrings.CREATOR_GLOBE,
        ATStrings.EARN_BY_COMPLETING_TASKS,
        ATStrings.TAKE_TASK_ND_GET_REWARDS
      ],
      <String>[
        ATImgStrings.CREATOR_LOCK,
        ATStrings.ENABLE_SUB_4_UR_SHOW,
        ATStrings.OFFER_XCLUSIVE_CONTENT
      ]
    ],
    UpgradeAcctType.business: <List<String>>[
      <String>[
        ATImgStrings.BIZ_THUNDER,
        ATStrings.PARTNER_WITH_CREATORS,
        ATStrings.COLLABORATE_WITH_CREATORS
      ],
      <String>[
        ATImgStrings.BIZ_TICKETS,
        ATStrings.SELL_TICKETS,
        ATStrings.MONETIZE_EVENTS
      ],
      <String>[
        ATImgStrings.CREATOR_MIC,
        ATStrings.HOST_BRANDED_AUDIO,
        ATStrings.ENGAGE_AUDIENCE
      ],
      <String>[
        ATImgStrings.BIZ_ARROW,
        ATStrings.PROMOTE_UR_BUSINESS,
        ATStrings.SHOWCASE_UR_PRODUCTS
      ]
    ]
  };

  @override
  Widget build(BuildContext context) {
    final bool isCreator = acctType == UpgradeAcctType.creator;
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
          body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: context.screenHeight * 0.3,
                    width: context.screenWidth,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        BlocSelector<AcctTypeLandingAnimBloc, List<bool>, bool>(
                            selector: (List<bool> state) => state.elementAt(0),
                            builder: (_, bool isVisible) {
                              return SpotlightBeam(
                                duration: 1500,
                                gradient: isVisible
                                    ? LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[
                                          ATColors.hex23221C,
                                          ATColors.black
                                        ],
                                      )
                                    : null,
                              );
                            }),
                        Positioned(
                          bottom: 0,
                          child: ATImgLoader(
                              imgPath: isCreator
                                  ? ATImgStrings.creatorAcctLogo
                                  : ATImgStrings.BIZ_ACCT_LOGO,
                              height: 70,
                              width: 80),
                        ),
                        const Positioned(
                            top: kToolbarHeight * 0.9,
                            left: 7,
                            child: ATXBackBtn())
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(
                      isCreator
                          ? ATStrings.AMPTIVE_4_CREATORS
                          : ATStrings.AMPTIVE_4_BIZ,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: ATSizes.size24),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(
                      isCreator
                          ? ATStrings.U_OWN_STAGE
                          : ATStrings.CONNECT_SELL,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: ATSizes.size13, color: ATColors.hexC2C2C2),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ...onboardContent[acctType]!.map((eachList) {
                    final int index = eachList.indexOf(eachList);
                    return _CustomWidget(
                      imgPath: eachList.first,
                      subTitle: eachList.last,
                      title: eachList[1],
                      index: index,
                    );
                  })
                ],
              )),
          bottomSheet: Builder(builder: (BuildContext context) {
            final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
            final double bottom = bottomInset == 0 ? 50.0 : 15.0;
            return Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 15, bottom),
                child: BlocSelector<AcctTypeLandingAnimBloc, List<bool>, bool>(
                    selector: (List<bool> state) => state.last,
                    builder: (_, bool isVisible) {
                      return ATPlainElevatedBtn(
                          onPressed: isVisible
                              ? () => context.pushNamed(ATRoutes.SELECT_CAT,
                                  extra: isCreator)
                              : null,
                          btnTitle: ATStrings.cContinue);
                    }));
          })),
    );
  }
}

class _CustomWidget extends StatelessWidget {
  const _CustomWidget(
      {required this.imgPath,
      required this.subTitle,
      required this.title,
      required this.index});
  final String imgPath, title, subTitle;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AcctTypeLandingAnimBloc, List<bool>, bool>(
        selector: (List<bool> state) => state.elementAt(index),
        builder: (_, bool isVisible) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isVisible ? 1 : 0,
            curve: Curves.decelerate,
            onEnd: () => isVisible
                ? context.read<AcctTypeLandingAnimBloc>().triggerNext(index + 1)
                : null,
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
                          title,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: ATSizes.size15),
                        ),
                        Text(
                          subTitle,
                          maxLines: 3,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: ATSizes.size13,
                                  color: ATColors.hexC2C2C2),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
