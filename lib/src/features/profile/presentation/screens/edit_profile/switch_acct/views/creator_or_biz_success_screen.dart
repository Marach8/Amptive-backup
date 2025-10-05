import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import '../switch_acct_export.dart';

class CreatorSuccessScreen extends StatelessWidget {
  const CreatorSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider(create: (_) => AccountTypeBloc()),
        BlocProvider(create: (_) => SwitchAcctSuccessAnimBloc())
      ],
      child: Builder(
        builder: (BuildContext blocsContext) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Future.delayed(
              const Duration(milliseconds: 500),
              () => blocsContext.mounted ? blocsContext.read<SwitchAcctSuccessAnimBloc>().triggerNext(0) : <dynamic, dynamic>{}
            )
          );
          
          return ATAnnotatedRegion(
            statusBarColor: ATColors.transparent,
            child: Scaffold(
              body: BlocSelector<SwitchAcctSuccessAnimBloc, List<bool>, bool>(
                selector: (List<bool> state) => state.elementAt(3),
                builder: (_, bool successState) {
                  if(successState){
                    return const CreatorOrBizSetupSuccess();
                  }
                  return const Center(child: CreatorOrBizSetupLoading());
                }
              ),
          
              bottomSheet: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: BlocSelector<SwitchAcctSuccessAnimBloc, List<bool>, bool>(
                  selector: (List<bool> state) => state.elementAt(3),
                  builder: (_, bool isVisible) {
                    return AnimatedSlide(
                      offset: isVisible ? const Offset(0, 0): const Offset(0, 1.5),
                      duration: const Duration(milliseconds: 500),
                      child: ATPlainElevatedBtn(
                        onPressed: (){},
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
