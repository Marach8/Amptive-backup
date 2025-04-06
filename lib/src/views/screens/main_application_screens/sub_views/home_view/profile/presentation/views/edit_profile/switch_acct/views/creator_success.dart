import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../../widgets/common_widgets/app_bar_widget.dart';
import '../../../../widgets/creator_badge.dart';
import '../switch_acct_export.dart';

class CreatorSuccessScreen extends StatelessWidget {
  const CreatorSuccessScreen({super.key});

  @override
  Widget build(context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        const Duration(milliseconds: 500),
        () => context.mounted ? context.read<CreatorSuccessAnimationBloc>().triggerNext(0) : {}
      )
    );

    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leadingWidth: 30,
          padding: const EdgeInsets.only(left: 7),
          leading: BlocSelector<CreatorSuccessAnimationBloc, List<bool>, bool>(
            selector: (state) => state.elementAt(3),
            builder: (_, successState) {
              if(successState)return const ATXBackBtn();
              return const SizedBox.shrink();
            }
          ),
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: BlocSelector<CreatorSuccessAnimationBloc, List<bool>, bool>(
              selector: (state) => state.elementAt(3),
              builder: (_, successState) {
                if(successState){
                  return const SuccesState();
                }
                return const LoadingState();
              }
            ),
          ),
        ),

        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: BlocSelector<CreatorSuccessAnimationBloc, List<bool>, bool>(
            selector: (state) => state.elementAt(3),
            builder: (_, isVisible) {
              if(isVisible){
                return ATPlainElevatedBtn(
                  onPressed: (){},
                  btnTitle: ATStrings.VISIT_PROFILE
                );
              }
              return const SizedBox.shrink();
            }
          ),
        ),
      ),
    );
  }
}
