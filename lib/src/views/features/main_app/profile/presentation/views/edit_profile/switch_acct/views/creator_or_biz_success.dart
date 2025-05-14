import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/features/main_app/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../switch_acct_export.dart';

class CreatorSuccessScreen extends StatelessWidget {
  const CreatorSuccessScreen({super.key});

  @override
  Widget build(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AccountTypeBloc()),
        BlocProvider(create: (_) => SwitchAcctSuccessAnimationBloc())
      ],
      child: Builder(
        builder: (blocsContext) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Future.delayed(
              const Duration(milliseconds: 500),
              () => blocsContext.mounted ? blocsContext.read<SwitchAcctSuccessAnimationBloc>().triggerNext(0) : {}
            )
          );
          
          return ATAnnotatedRegion(
            statusBarColor: ATColors.trsprnt,
            child: Scaffold(
              body: BlocSelector<SwitchAcctSuccessAnimationBloc, List<bool>, bool>(
                selector: (state) => state.elementAt(3),
                builder: (_, successState) {
                  if(successState){
                    return const CreatorOrBizSetupSuccess();
                  }
                  return const Center(child: CreatorOrBizSetupLoading());
                }
              ),
          
              bottomSheet: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: BlocSelector<SwitchAcctSuccessAnimationBloc, List<bool>, bool>(
                  selector: (state) => state.elementAt(3),
                  builder: (_, isVisible) {
                    return ATAnimatedCrossFade(
                      condition: isVisible,
                      secondChild: const SizedBox.shrink(),
                      firstChild: ATPlainElevatedBtn(
                        onPressed: (){
                          Navigator.popUntil(context, (route) => route.isFirst);
                          context.pushNamed(ATRoutes.CREATOR_PROFILE_SCREEN);
                        },
                        btnTitle: ATStrings.VISIT_PROFILE
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
