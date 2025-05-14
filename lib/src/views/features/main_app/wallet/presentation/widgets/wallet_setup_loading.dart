import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/features/main_app/wallet/bloc/wallet_bloc_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class WalletCreationLoading extends StatelessWidget {
  const WalletCreationLoading({super.key});

  static const walletList = [ATStrings.CREATING_WALLET, ATStrings.PREPARING_WALLET, ATStrings.FINALIZING_SETUP];

  @override
  Widget build(BuildContext context) {   
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: walletList.map(
              (item){
                final index = walletList.indexOf(item);
                return BlocSelector<WalletCreationAnimBloc, List<bool>, bool>(
                  selector: (state) => state.elementAt(index),
                  builder: (_, isVisible) {
                    return AnimatedPositioned(
                      bottom: isVisible ? 0 : -30,
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 500),
                      onEnd: () => isVisible ? 
                        Future.delayed(
                          const Duration(milliseconds: 2500),
                          () => context.mounted ? context.read<WalletCreationAnimBloc>().triggerNext(index + 1) : {}
                        ) : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Text(
                            item, 
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: ATFontSizes.size17
                            )
                          ),
                          const Icon(Icons.check,)
                        ],
                      ),
                    );
                  }
                );
              }
            ).toList(),
          ),
        ),
        const SizedBox(height: 20),
        const ATLoadingIndicator()
      ],
    );
  }
}