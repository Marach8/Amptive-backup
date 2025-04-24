import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/features/main_app/wallet/bloc/wallet_landing_anim_bloc.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ATWalletLandingScreen extends StatelessWidget {
  const ATWalletLandingScreen({super.key});

  static const _list = <String>[ATStrings.UR_WALLET, ATStrings.UR_WAY];

  @override
  Widget build(_) {
    return BlocProvider(
      create: (_) => WalletLandingAnimBloc(),
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_){
              context.read<WalletLandingAnimBloc>().reset();
              Future.delayed(
                const Duration(milliseconds: 1000),
                () => context.mounted ? context.read<WalletLandingAnimBloc>().triggerNext(0) : {}
              );
            }
          );

          return ATAnnotatedRegion(
            child: Scaffold(
              appBar: const ATAppBar(
                leading: ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: EdgeInsets.only(left: 5),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocSelector<WalletLandingAnimBloc, List<bool>, bool>(
                      selector: (state) => state.last,
                      builder: (_, isDone) {
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: isDone ? 1 : 0, curve: Curves.decelerate,
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const ATImgLoader(imgPath: ATImgStrings.BIG_WALLET_ICON),
                              Text(
                                ATStrings.SETUP_WALLET,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              Text(
                                '${ATStrings.UR_WALLET}, ${ATStrings.UR_WAY}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ATColors.hexC2C2C2
                                )
                              ),
                            ],
                          ),
                        );
                      }
                    ),

                    BlocSelector<WalletLandingAnimBloc, List<bool>, bool>(
                      selector: (state) => state.last,
                      builder: (_, isDone) {
                        if(isDone) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 150),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _list.map(
                              (item) => _CustomWidget(text: item, index: _list.indexOf(item))
                            ).toList(),
                          ),
                        );                       
                      }
                    ),
                  ],
                )
              ),

              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: BlocSelector<WalletLandingAnimBloc, List<bool>, bool>(
                  selector: (state) => state.last,
                  builder: (_, isDone) {
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: isDone ? 1 : 0, curve: Curves.decelerate,
                      child: Column(
                        spacing:10,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ATContainer(
                            radius: 14,
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            color: ATColors.white.withValues(alpha: 0.05),
                            child: Row(
                              spacing: 10,
                              children: [
                                const ATImgLoader(imgPath: ATImgStrings.WARNING_ICON),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ATStrings.NO_WALLET_NO_EARNINGS,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontSize: ATFontSizes.size15
                                        ),
                                      ),
                                      Text(
                                        ATStrings.SETUP_UR_WALLET, maxLines: 3,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontSize: ATFontSizes.size13,
                                          color: ATColors.hexC2C2C2
                                        )
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ),
                          ATPlainElevatedBtn(
                            onPressed: (){context.pushReplacementNamed(ATRoutes.WALLET_PIN_SETUP);},
                            btnTitle: ATStrings.BEGIN_SETUP,
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
            )
          );
        }
      ),
    );
  }
}





class _CustomWidget extends StatelessWidget {
  const _CustomWidget({
    required this.text,
    required this.index
  });
  final String text;
  final int index;

  @override
  Widget build(context) {
    return BlocSelector<WalletLandingAnimBloc, List<bool>, bool>(
      selector: (state) => state.elementAt(index),
      builder: (_, isVisible) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isVisible ? 1 : 0, curve: Curves.decelerate,
          onEnd: () => isVisible? context.read<WalletLandingAnimBloc>().triggerNext(index + 1): null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(
              text.toUpperCase(),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: ATColors.hexC2C2C2,
                fontSize: 40,
                fontWeight: ATFontWeights.w800
              ),
            )
          ),
        );
      }
    );
  }
}

