import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/select_acct_type_screen.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/spotlight_beam.dart';
import '../../../../config/routing/route_strings.dart';
import '../../../profile/presentation/widgets/creator_or_business_badge.dart';


class AccountUpgradeSuccessScreen extends StatefulWidget {
  const AccountUpgradeSuccessScreen({
    super.key, required this.accountType});
  final AccountType accountType;

  @override
  State<AccountUpgradeSuccessScreen> createState() 
    => _AccountUpgradeSuccessScreenState();
}

class _AccountUpgradeSuccessScreenState 
  extends State<AccountUpgradeSuccessScreen>{
  bool isVisible = false;

  @override 
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        Future<void>.delayed(
          const Duration(milliseconds: 400),
          (){
            setState(() => isVisible = true);
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCreator = 
      widget.accountType == AccountType.creator;
    final String? image = context
      .read<LocalUserDataCubit>()
        .currentUserData?.profilePhoto;

    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: context.screenHeight * 0.4,
              width: context.screenWidth,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: <Widget>[
                  SpotlightBeam(
                    gradient: isVisible ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        ATColors.hex23221C,
                        ATColors.black
                      ],
                    ) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: ATImgLoader(
                        height: 70, width: 70,
                        boxFit: BoxFit.cover,
                        imgPath: image ?? ATImgStrings.noAvatarImage
                      ),
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isVisible ? 1 : 20,
                      child: AccountUpgradeBadge(accountType: widget.accountType),
                    ),
                  ),
                  const Positioned(
                    top: kToolbarHeight * 0.9,
                    left: 7, child: ATXBackBtn())
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                isCreator ? ATStrings.youAreACreator : ATStrings.yourBusinessIsReady,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: ATSizes.size24),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                  isCreator ? ATStrings.nowYouCanCreate
                  : ATStrings.expandYourBiz,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall
                    ?.copyWith(color: ATColors.hexC2C2C2)),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 60),
          child: AnimatedSlide(
              offset: isVisible
                  ? const Offset(0, 0)
                  : const Offset(0, 2.5),
              duration: const Duration(milliseconds: 500),
              child: ATPlainElevatedBtn(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (Route<dynamic> route) {
                        return route.settings.name ==
                          ATRoutes.mainProfileScreen;
                      },
                    );
                  },
                  btnTitle: ATStrings.visitProfile)),
        ),
      ),
    );
  }
}
