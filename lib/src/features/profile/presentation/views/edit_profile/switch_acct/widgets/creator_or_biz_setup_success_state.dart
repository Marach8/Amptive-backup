import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/features/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/features/profile/presentation/profile_prez_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/creator_or_business_badge.dart';


class CreatorOrBizSetupSuccess extends StatelessWidget {
  const CreatorOrBizSetupSuccess({super.key});

  @override
  Widget build(context) {
    final isCreator = context.read<AccountTypeBloc>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: ATHelperFuncs.getScreenHeight(context) * 0.4,
          width: ATHelperFuncs.getScreenWidth(context),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              BlocSelector<SwitchAcctSuccessAnimBloc, List<bool>, bool>(
                selector: (state) => state.elementAt(4),
                builder: (_, isVisible) {
                  return SpotlightBeam(
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
              const Positioned(
                bottom: 0,
                child: ATCircularImage(
                  diameter: 70,
                  imagePath: ATImgStrings.jpeg1
                ),
              ),
              Positioned(
                bottom: 0,
                child: BlocSelector<SwitchAcctSuccessAnimBloc, List<bool>, bool>(
                  selector: (state) => state.elementAt(4),
                  builder: (_, isVisible) {
                    return AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isVisible ? 1 : 20,
                      child: CreatorOrBizBadge(isCreator: isCreator),
                    );
                  }
                ),
              ),
              const Positioned(
                top: kToolbarHeight * 0.9, left: 7,
                child: ATXBackBtn()
              )
            ],
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            isCreator ? ATStrings.U_R_A_CREATOR : ATStrings.UR_BIZ_IS_READY, 
            maxLines: 2, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: ATFontSizes.size24
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            isCreator ? ATStrings.NOW_U_CAN_CREATE : ATStrings.EXPAND_UR_BIZ, 
            maxLines: 2, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ATColors.hexC2C2C2
            )
          ),
        ),
      ],
    );
  }
}
