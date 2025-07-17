import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/wallet/bloc/wallet_landing_anim_bloc.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_align_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ATWalletOnboardScreen extends StatelessWidget {
  const ATWalletOnboardScreen({super.key});

  static const List<String> _list = <String>[ATStrings.UR_WALLET, ATStrings.UR_WAY];

  @override
  Widget build(_) {
    return BlocProvider(
      create: (_) => WalletOnboardAnimBloc(),
      child: Builder(
        builder: (BuildContext context) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_){
              context.read<WalletOnboardAnimBloc>().reset();
              Future.delayed(
                const Duration(milliseconds: 1000),
                () => context.mounted ? context.read<WalletOnboardAnimBloc>().triggerNext(0) : <dynamic, dynamic>{}
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
                  children: <Widget>[
                    BlocSelector<WalletOnboardAnimBloc, List<bool>, bool>(
                      selector: (List<bool> state) => state.elementAt(2),
                      builder: (_, bool isDone) {
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: isDone ? 1 : 0, curve: Curves.decelerate,
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
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

                    BlocSelector<WalletOnboardAnimBloc, List<bool>, bool>(
                      selector: (List<bool> state) => state.elementAt(2),
                      builder: (_, bool isDone) {
                        if(isDone) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 150),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _list.map(
                              (String item) => _CustomWidget(text: item, index: _list.indexOf(item))
                            ).toList(),
                          ),
                        );                       
                      }
                    ),
                  ],
                )
              ),

              bottomNavigationBar: Column(
                spacing:10,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BlocSelector<WalletOnboardAnimBloc, List<bool>, bool>(
                    selector: (List<bool> state) => state.last,
                    builder: (_, bool isDone) {
                      return ATAnimatedAlign(
                        condition: !isDone,
                        startAlignment: Alignment(-ATHelperFuncs.getScreenWidth(context), 0),
                        endAlignment: Alignment.center,
                        child: ATContainer(
                          radius: 14,
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          width: ATHelperFuncs.getScreenWidth(context) * 0.92,
                          color: ATColors.white.withValues(alpha: 0.05),
                          child: Row(
                            spacing: 10,
                            children: <Widget>[
                              const ATImgLoader(imgPath: ATImgStrings.WARNING_ICON),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
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
                      );
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                    child: BlocSelector<WalletOnboardAnimBloc, List<bool>, bool>(
                      selector: (List<bool> state) => state.elementAt(2),
                      builder: (_, bool isDone) {
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: isDone ? 1 : 0, curve: Curves.decelerate,
                          child: ATPlainElevatedBtn(
                            onPressed: (){context.pushReplacementNamed(ATRoutes.WALLET_PIN_SETUP);},
                            btnTitle: ATStrings.BEGIN_SETUP,
                          ),
                        );
                      }
                    ),
                  ),
                ],
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
  Widget build(BuildContext context) {
    return BlocSelector<WalletOnboardAnimBloc, List<bool>, bool>(
      selector: (List<bool> state) => state.elementAt(index),
      builder: (_, bool isVisible) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isVisible ? 1 : 0, curve: Curves.decelerate,
          onEnd: () => isVisible? context.read<WalletOnboardAnimBloc>().triggerNext(index + 1): null,
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

