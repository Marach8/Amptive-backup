import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/wallet/bloc/wallet_bloc_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class WalletCreationLoading extends StatelessWidget {
  const WalletCreationLoading({super.key});

  static const List<String> walletList = <String>[
    ATStrings.CREATING_WALLET,
    ATStrings.PREPARING_WALLET,
    ATStrings.FINALIZING_SETUP
  ];

  @override
  Widget build(BuildContext context) {   
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: walletList.map(
              (String item){
                final int index = walletList.indexOf(item);
                return BlocSelector<WalletCreationAnimBloc, List<bool>, bool>(
                  selector: (List<bool> state) => state.elementAt(index),
                  builder: (_, bool isVisible) {
                    return AnimatedPositioned(
                      bottom: isVisible ? 0 : -30,
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 500),
                      onEnd: () => isVisible ? 
                        Future<void>.delayed(
                          const Duration(milliseconds: 2500),
                          () => context.mounted ? context.read<WalletCreationAnimBloc>().triggerNext(index + 1) : <dynamic, dynamic>{}
                        ) : null,
                      child:Text(
                        item, 
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: ATSizes.size17
                        )
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
