import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/select_acct_type_screen.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/spotlight_beam.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectedAcctOnboardScreen extends StatefulWidget {
  const SelectedAcctOnboardScreen({
    super.key,
    required this.acctType,
  });

  final AccountType acctType;

  @override
  State<SelectedAcctOnboardScreen> createState() => _SelectedAcctOnboardScreenState();
}

class _SelectedAcctOnboardScreenState extends State<SelectedAcctOnboardScreen> {
  static const Map<AccountType, List<List<String>>> onboardContent =
      <AccountType, List<List<String>>>{
    AccountType.creator: <List<String>>[
      <String>[
        ATImgStrings.CREATOR_MIC,
        ATStrings.CREATE_LIVE_SHOWS_ND_EVENTS,
        ATStrings.HOST_CAPTIVATING_PROGRAMS,
      ],
      <String>[
        ATImgStrings.CREATOR_GIF,
        ATStrings.RECEIVE_GIFTS_4RM_AUDIENCE,
        ATStrings.GET_SUPPORT_4RM_FANS,
      ],
      <String>[
        ATImgStrings.CREATOR_GLOBE,
        ATStrings.EARN_BY_COMPLETING_TASKS,
        ATStrings.TAKE_TASK_ND_GET_REWARDS,
      ],
      <String>[
        ATImgStrings.CREATOR_LOCK,
        ATStrings.ENABLE_SUB_4_UR_SHOW,
        ATStrings.OFFER_XCLUSIVE_CONTENT,
      ],
    ],
    AccountType.business: <List<String>>[
      <String>[
        ATImgStrings.BIZ_THUNDER,
        ATStrings.PARTNER_WITH_CREATORS,
        ATStrings.COLLABORATE_WITH_CREATORS,
      ],
      <String>[
        ATImgStrings.BIZ_TICKETS,
        ATStrings.SELL_TICKETS,
        ATStrings.MONETIZE_EVENTS,
      ],
      <String>[
        ATImgStrings.CREATOR_MIC,
        ATStrings.HOST_BRANDED_AUDIO,
        ATStrings.ENGAGE_AUDIENCE,
      ],
      <String>[
        ATImgStrings.BIZ_ARROW,
        ATStrings.PROMOTE_UR_BUSINESS,
        ATStrings.SHOWCASE_UR_PRODUCTS,
      ],
    ],
  };

  final GlobalKey<AnimatedListState> _listKey =
      GlobalKey<AnimatedListState>();

  final List<List<String>> _visibleItems = <List<String>>[];

  bool _canContinue = false;

  List<List<String>> get _items =>
      onboardContent[widget.acctType]!;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await Future<void>.delayed(
        const Duration(milliseconds: 500));
      _insertNextItem(0);
    });
  }

  Future<void> _insertNextItem(int index) async {
    if (!mounted) return;

    if (index >= _items.length) {
      setState(() => _canContinue = true);
      return;
    }

    _visibleItems.add(_items[index]);

    _listKey.currentState?.insertItem(
      _visibleItems.length - 1,
      duration: const Duration(milliseconds: 500),
    );

    await Future<void>.delayed(
      const Duration(milliseconds: 450),
    );

    _insertNextItem(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    final bool isCreator =
        widget.acctType == AccountType.creator;

    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: context.screenHeight * 0.3,
              width: context.screenWidth,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  SpotlightBeam(
                    duration: 1500,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        ATColors.hex23221C,
                        ATColors.black,
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: ATImgLoader(
                      imgPath: isCreator
                          ? ATImgStrings.creatorAcctLogo
                          : ATImgStrings.businessAcctMicLogo,
                      height: 70,
                      width: 80,
                    ),
                  ),
                  const Positioned(
                    top: kToolbarHeight * 0.9,
                    left: 7,
                    child: ATXBackBtn(),
                  ),
                ],
              ),
            ),
        
            const SizedBox(height: 40),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                isCreator
                    ? ATStrings.amptiveForCreators
                    : ATStrings.amptiveForBusiness,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: ATSizes.size24),
              ),
            ),
        
            const SizedBox(height: 5),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                isCreator
                    ? ATStrings.U_OWN_STAGE
                    : ATStrings.CONNECT_SELL,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(
                      fontSize: ATSizes.size13,
                      color: ATColors.hexC2C2C2,
                    ),
              ),
            ),
        
            const SizedBox(height: 20),
        
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: 0,
                padding: const EdgeInsets.only(bottom: 120),
                itemBuilder: (_, int index, Animation<double> animation) {
                  final List<String> item = _visibleItems[index];
                      
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          end: const Offset(0, 0.15),
                          begin: Offset.zero,
                        ),
                      ),
                      child: _CustomWidget(
                        imgPath: item[0],
                        title: item[1],
                        subTitle: item[2],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
          child: ATPlainElevatedBtn(
            onPressed: _canContinue
                ? () => context.pushReplacementNamed(
                      ATRoutes.selectCategoriesScreen,
                      extra: widget.acctType
                    )
                : null,
            btnTitle: ATStrings.cContinue,
          ),
        )
      ),
    );
  }
}

class _CustomWidget extends StatelessWidget {
  const _CustomWidget({
    required this.imgPath,
    required this.title,
    required this.subTitle,
  });

  final String imgPath;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  style: context.textTheme.bodySmall
                      ?.copyWith(
                        fontSize: ATSizes.size15,
                      ),
                ),
                Text(
                  subTitle,
                  maxLines: 3,
                  style: context.textTheme.titleSmall
                      ?.copyWith(
                        fontSize: ATSizes.size13,
                        color: ATColors.hexC2C2C2,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
