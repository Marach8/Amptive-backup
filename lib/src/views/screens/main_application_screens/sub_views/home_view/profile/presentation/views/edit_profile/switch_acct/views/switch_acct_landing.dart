import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../bloc/profile_bloc_export.dart';
import '../../edit_profile_export.dart' show SpotlightBeam;

class SelectedAcctLandingScreen extends StatelessWidget {
  const SelectedAcctLandingScreen({super.key, required this.isCreator});
  final bool isCreator;

  static const creatorList = <List<String>>[
    [ATImgStrings.CREATOR_MIC, ATStrings.CREATE_LIVE_SHOWS_ND_EVENTS, ATStrings.HOST_CAPTIVATING_PROGRAMS],
    [ATImgStrings.CREATOR_GIF, ATStrings.RECEIVE_GIFTS_4RM_AUDIENCE, ATStrings.GET_SUPPORT_4RM_FANS],
    [ATImgStrings.CREATOR_GLOBE, ATStrings.EARN_BY_COMPLETING_TASKS, ATStrings.TAKE_TASK_ND_GET_REWARDS],
    [ATImgStrings.CREATOR_LOCK, ATStrings.ENABLE_SUB_4_UR_SHOW, ATStrings.OFFER_XCLUSIVE_CONTENT]
  ];

  static const businessList = <List<String>>[
    [ATImgStrings.BIZ_THUNDER, ATStrings.PARTNER_WITH_CREATORS, ATStrings.COLLABORATE_WITH_CREATORS],
    [ATImgStrings.BIZ_TICKETS, ATStrings.SELL_TICKETS, ATStrings.MONETIZE_EVENTS],
    [ATImgStrings.CREATOR_MIC, ATStrings.HOST_BRANDED_AUDIO, ATStrings.ENGAGE_AUDIENCE],
    [ATImgStrings.BIZ_ARROW, ATStrings.PROMOTE_UR_BUSINESS, ATStrings.SHOWCASE_UR_PRODUCTS]
  ];

  @override
  Widget build(context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        const Duration(milliseconds: 500),
        () => context.mounted ? context.read<CreatorLandingAnimationBloc>().triggerNext(0) : {}
      )
    );

    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprnt,
      child: AccountStatusProvider(
        isCreator: isCreator,
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: ATHelperFuncs.getScreenHeight(context) * 0.3,
                  width: ATHelperFuncs.getScreenWidth(context),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      BlocSelector<CreatorLandingAnimationBloc, List<bool>, bool>(
                        selector: (state) => state.elementAt(0),
                        builder: (_, isVisible) {
                          return SpotlightBeam(
                            duration: 1500,
                            gradient: isVisible ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
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
                      fontSize: ATFontSizes.size24
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(
                    isCreator ? ATStrings.U_OWN_STAGE : ATStrings.CONNECT_SELL,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: ATFontSizes.size13,
                      color: ATColors.hexC2C2C2
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                
                ...(isCreator ? creatorList : businessList).asMap().entries.map(
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
        
          bottomSheet: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
            child: BlocSelector<CreatorLandingAnimationBloc, List<bool>, bool>(
              selector: (state) => state.last,
              builder: (_, isVisible) {
                return ATPlainElevatedBtn(
                  onPressed: isVisible ? () => context.pushNamed(ATRoutes.SELECT_CAT) : null,
                  btnTitle: ATStrings.CONTINUE
                );
              }
            )
          ),
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
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
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




class AccountStatusProvider extends InheritedWidget{
  final bool isCreator;

  const AccountStatusProvider({
    super.key, 
    required super.child,
    required this.isCreator,
  });

  static AccountStatusProvider? of(BuildContext context)
    => context.dependOnInheritedWidgetOfExactType<AccountStatusProvider>();

  
  @override
  bool updateShouldNotify(covariant AccountStatusProvider oldWidget)
    => oldWidget.isCreator != isCreator;
}