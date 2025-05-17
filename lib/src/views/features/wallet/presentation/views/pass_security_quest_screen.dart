import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer';
import '../../../../widgets/common_widgets/elevated_button_widget.dart';

class ATPassSecurityQuestionScreen extends StatelessWidget {
  const ATPassSecurityQuestionScreen({super.key});

  static String quest = 'What is your childhood nickname?';

  @override
  Widget build(BuildContext _) {
    return ATAnnotatedRegion(
      child: BlocProvider(
        create: (_) => _EnterSecretQuesBloc(),
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: const ATAppBar(
                leading: ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: EdgeInsets.only(left: 7),
                titleText: ATStrings.ANSWER_SECRET_QUEST
              ),
            
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 2,
                      quest,
                      style: Theme.of(context).textTheme.bodySmall
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<_EnterSecretQuesBloc, int?>(
                      buildWhen: (prev, _) => prev == null || prev == 0,
                      builder: (_, state){
                        return ATTextFormField(
                          enabled: state != 0,
                          fillColor: ATColors.white.withValues(alpha: 0.1),
                          hintText: ATStrings.ENTER_UR_ANS,
                          suffixIcon: const _SuffixIcon(),
                          onChanged: (text) => ATHelperFuncs.callDebouncer(
                            2000,
                            () => context.read<_EnterSecretQuesBloc>().checkAnswer(text)
                          )
                        );
                      }
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<_EnterSecretQuesBloc, int?>(
                      builder: (_, state){
                        if(state == null){
                          return Text(
                            ATStrings.ANS_IS_CASE_SENSITIVE,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: ATFontSizes.size11
                            ),
                          );
                        }
                        else if(state == 0){
                          return Text(
                            ATStrings.CHECKER_LOADING,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: ATFontSizes.size11
                            ),
                          );
                        }
                        else if(state == 1){
                          return Text(
                            ATStrings.CORRECT_ANS,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: ATFontSizes.size11,
                              color: ATColors.successColor
                            ),
                          );
                        }
                        else {
                          return Text(
                            ATStrings.INCORRECT_ANS,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: ATFontSizes.size11,
                              color: ATColors.textRedColor
                            ),
                          );
                        }
                        
                      }
                    ),
                  ],
                ),
              ),

              bottomSheet: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: BlocBuilder<_EnterSecretQuesBloc, int?>(
                  builder: (_, state){
                    return ATPlainElevatedBtn(
                      onPressed: state == 1 ? () => context.pop(true) : null,
                      btnTitle: ATStrings.SEND_WITHDRAWAL_REQUEST
                    );
                  }
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

class _SuffixIcon extends StatelessWidget {
  const _SuffixIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<_EnterSecretQuesBloc, int?>(
        builder: (_, state){
          if(state == null){
            return const SizedBox.shrink();
          }
          else if(state == 0){
            return const Padding(
              padding: EdgeInsets.only(right: 10),
              child: ATLoadingIndicator(size: 20,),
            );
          }
          else if(state == 1){
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check,
                color: ATColors.successColor,
              ),
            );
          }
          else {
            return Icon(
              Icons.close,
              color: ATColors.textRedColor,
            );
          }
        },
      ),
    );
  }
}


class _EnterSecretQuesBloc extends Cubit<int?> {
  _EnterSecretQuesBloc() : super(null);
  final String ans = 'Emmanuel';
  void checkAnswer(String input)async{ 
    if(input.isEmpty){
      emit(null);
      return;
    }
    
    emit(0);
    await Future.delayed(const Duration(seconds: 3));
    if(input == ans){
      emit(1);
    }
    else{
      emit(2);
    }
  }
}
