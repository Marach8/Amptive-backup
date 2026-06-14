import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatorOrBusinessSetupLoading extends StatelessWidget {
  const CreatorOrBusinessSetupLoading({super.key});

  static const List<String> creatorList = <String>[
    ATStrings.CAT_SELECETED,
    ATStrings.SUB_FEE_SETUP,
    ATStrings.cohostFeeSetup
  ];
  static const List<String> bizList = <String>[
    ATStrings.CAT_SELECETED,
    ATStrings.SETTING_UP_ACCT,
    ATStrings.ALMOST_THERE
  ];

  @override
  Widget build(BuildContext context) {
    final bool isCreator = context.read<AccountTypeBloc>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: (isCreator ? creatorList : bizList).map((String item) {
              final int index =
                  (isCreator ? creatorList : bizList).indexOf(item);
              return BlocSelector<SwitchAcctSuccessAnimBloc, List<bool>, bool>(
                  selector: (List<bool> state) => state.elementAt(index),
                  builder: (_, bool isVisible) {
                    return AnimatedPositioned(
                      bottom: isVisible ? 0 : -30,
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 500),
                      onEnd: () => isVisible
                          ? Future.delayed(
                              const Duration(milliseconds: 2500),
                              () => context.mounted
                                  ? context
                                      .read<SwitchAcctSuccessAnimBloc>()
                                      .triggerNext(index + 1)
                                  : <dynamic, dynamic>{})
                          : null,
                      child: Text(item,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: ATSizes.size17)),
                    );
                  });
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        const ATLoadingIndicator()
      ],
    );
  }
}
