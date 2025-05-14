import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/wallet/security_questions.dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/widgets/security_answer_field.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/security_question_bloc.dart';


class ATSecurityQuestionScreen extends StatelessWidget {
  const ATSecurityQuestionScreen({super.key});

  static const items = [
    'What is the name of your mother?',
    'What is the name of your father?',
    'What is the name of your first uncle?',
    'What is the name of the secondary school that your went to?',
    'How old are you?',
    'Do you have a girlfriend?',
    'What is the worst life experience you have had in the past?'
  ];

  @override
  Widget build(_) {
    return ATAnnotatedRegion(
      child: BlocProvider(
        create: (_) => SecQuestionBloc(),
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: const ATAppBar(
                leading: ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: EdgeInsets.only(left: 7),
                titleText: ATStrings.WALLET_SETUP,
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ATStrings.SELECT_SECURITY_QUEST,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    const SizedBox(height: 10,),
                    ATContainer(
                      onTap: ()async {
                        context.read<SecQuestionBloc>().toggleIcon();

                        final result = await showSecurityQuestionsDialog(context, items);
                        if(result != null && context.mounted){
                          context.read<SecQuestionBloc>().setSecQuestion(result);
                        }
                        
                        if(context.mounted){
                          context.read<SecQuestionBloc>().toggleIcon();
                        }
                      },
                      color: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                      radius: 14,
                      width: ATHelperFuncs.getScreenWidth(context),
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: [
                          BlocSelector<SecQuestionBloc, (String?, bool, String), String?>(
                            selector: (state) => state.$1,
                            builder: (_, state) {
                              return Expanded(
                                child: Text(
                                  state ?? ATStrings.A_QUEST_U_CAN_REMEMBER, maxLines: 3,
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: state == null ? ATColors.hex5B5B5B : ATColors.white,
                                  )
                                ),
                              );
                            }
                          ),
                          const SizedBox(width: 20,),
                          BlocSelector<SecQuestionBloc, (String?, bool, String), bool>(
                            selector: (state) => state.$2,
                            builder: (_, state) {
                              return Icon(
                                state ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, 
                                size: 30,
                              );
                            }
                          )
                        ],
                      ),
                    ),
            
                    const SizedBox(height: 20,),

                    BlocSelector<SecQuestionBloc, (String?, bool, String), String?>(
                      selector: (state) => state.$1,
                      builder: (_, state) {
                        return ATAnimatedCrossFade(
                          condition: state == null,
                          firstChild: const SizedBox.shrink(),
                          secondChild: const SecurityAnswerField(),
                        );
                      }
                    )
                  ],
                ),
              ),
            
              bottomSheet: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: BlocSelector<SecQuestionBloc, (String?, bool, String), String>(
                  selector: (state) => state.$3,
                  builder: (_, state) {
                    return ATPlainElevatedBtn(
                      onPressed: state.isEmpty ? null : ()
                        => context.pushReplacementNamed(ATRoutes.WALLET_CREATION_ANIM),
                      btnTitle: ATStrings.FINISH_SETUP
                    );
                  }
                ),
              ),
            );
          }
        ),
      )
    );
  }
}
