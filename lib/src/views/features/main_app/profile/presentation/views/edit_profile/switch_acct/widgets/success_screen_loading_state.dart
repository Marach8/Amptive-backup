import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/features/main_app/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  static const creatorList = [ATStrings.CAT_SELECETED, ATStrings.SUB_FEE_SETUP, ATStrings.COHOST_FEE_SETUP];
  static const bizList = [ATStrings.CAT_SELECETED, ATStrings.SETTING_UP_ACCT, ATStrings.ALMOST_THERE];

  @override
  Widget build(BuildContext context) {   
    final isCreator = context.read<AccountTypeBloc>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: (isCreator ? creatorList : bizList).map(
              (item){
                final index = (isCreator ? creatorList : bizList).indexOf(item);
                return BlocSelector<SwitchAcctSuccessAnimationBloc, List<bool>, bool>(
                  selector: (state) => state.elementAt(index),
                  builder: (_, isVisible) {
                    return AnimatedPositioned(
                      bottom: isVisible ? 0 : -30,
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 500),
                      onEnd: () => isVisible ? 
                        Future.delayed(
                          const Duration(milliseconds: 2500),
                          () => context.mounted ? context.read<SwitchAcctSuccessAnimationBloc>().triggerNext(index + 1) : {}
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