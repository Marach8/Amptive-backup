import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/spotlight_beam.dart';
import 'package:flutter/material.dart';



import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/wallet_bloc_export.dart';


class WalletCretionSuccess extends StatelessWidget {
  const WalletCretionSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: ATHelperFuncs.getScreenHeight(context) * 0.5,
          width: ATHelperFuncs.getScreenWidth(context),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: <Widget>[
              BlocSelector<WalletCreationAnimBloc, List<bool>, bool>(
                selector: (List<bool> state) => state.elementAt(3),
                builder: (_, bool isVisible) {
                  return SpotlightBeam(
                    width: ATHelperFuncs.getScreenWidth(context),
                    height: ATHelperFuncs.getScreenHeight(context) * 0.45,
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
              const Positioned(
                bottom: 0,
                child: ATImgLoader(imgPath: ATImgStrings.BIG_WALLET_COLORED_ICON,),
              ),

              const Positioned(
                top: kToolbarHeight * 0.9, left: 7,
                child: ATXBackBtn()
              )
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            ATStrings.WALLET_CREATED,
            maxLines: 2, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: ATSizes.size24
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            ATStrings.RECEIVE_EARNINGS_WITH_WALLET,
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