import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/wallet/bloc/wallet_creation_anim_bloc.dart';
import 'package:amptive/src/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ATWalletCreationAnimScreen extends StatelessWidget {
  const ATWalletCreationAnimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletCreationAnimBloc(),
      child: Builder(
        builder: (BuildContext blocContext) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Future.delayed(
              const Duration(milliseconds: 500),
              () => blocContext.mounted ? blocContext.read<WalletCreationAnimBloc>().triggerNext(0) : <dynamic, dynamic>{}
            )
          );
          
          return ATAnnotatedRegion(
            statusBarColor: ATColors.trsprnt,
            child: Scaffold(
              body: BlocSelector<WalletCreationAnimBloc, List<bool>, bool>(
                selector: (List<bool> state) => state.elementAt(3),
                builder: (_, bool successState) {
                  if(successState){
                    return const WalletCretionSuccess();
                  }
                  return const Center(child: WalletCreationLoading());
                }
              ),
          
              bottomSheet: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: BlocSelector<WalletCreationAnimBloc, List<bool>, bool>(
                  selector: (List<bool> state) => state.elementAt(3),
                  builder: (_, bool isVisible) {
                    return ATAnimatedXFade(
                      condition: isVisible,
                      secondChild: const SizedBox.shrink(),
                      firstChild: ATPlainElevatedBtn(
                        onPressed: (){
                          context.pushReplacementNamed(ATRoutes.WALLET);
                        },
                        btnTitle: ATStrings.OPEN_WALLET
                      )
                    );
                  }
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
