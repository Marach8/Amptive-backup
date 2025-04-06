import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [ATStrings.CAT_SELECETED, ATStrings.SUB_FEE_SETUP, ATStrings.COHOST_FEE_SETUP];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: list.map(
              (item){
                final index = list.indexOf(item);
                return BlocSelector<CreatorSuccessAnimationBloc, List<bool>, bool>(
                  selector: (state) => state.elementAt(index),
                  builder: (_, isVisible) {
                    return AnimatedPositioned(
                      bottom: isVisible ? 0 : -30,
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 500),
                      onEnd: () => isVisible ? 
                        Future.delayed(
                          const Duration(milliseconds: 2500),
                          () => context.mounted ? context.read<CreatorSuccessAnimationBloc>().triggerNext(index + 1) : {}
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