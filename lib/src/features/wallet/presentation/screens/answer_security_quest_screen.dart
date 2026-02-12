import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/wallet/presentation/screens/transaction_amount_screen.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/elevated_button_widget.dart';

class ATAnswerSecurityQuestionScreen extends StatelessWidget {
  const ATAnswerSecurityQuestionScreen({super.key});

  static String quest = 'What is your childhood nickname?';

  @override
  Widget build(BuildContext _) {
    return ATAnnotatedRegion(
      child: BlocProvider(
        create: (_) => _EnterSecretQuesBloc(),
        child: Builder(
          builder: (BuildContext context) {
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
                  children: <Widget>[
                    Text(
                      maxLines: 2,
                      quest,
                      style: context.textTheme.bodySmall
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<_EnterSecretQuesBloc, int?>(
                      buildWhen: (int? prev, _) => prev == null || prev == 0,
                      builder: (_, int? state){
                        return ATTextFormField(
                          enabled: state != 0,
                          disableBlueBorder: true,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: ATImgLoader(
                              height: 20, width: 20,
                              imgPath: ATImgStrings.outlinedSearch
                            ),
                          ),
                          fillColor: ATColors.white.withValues(alpha: 0.1),
                          hintText: ATStrings.enterYourAnswer,
                          suffixIcon: const _SuffixIcon(),
                          onChanged: (String text) => ATHelperFuncs.callDebouncer(
                            2000,
                            () => context.read<_EnterSecretQuesBloc>().checkAnswer(text)
                          )
                        );
                      }
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<_EnterSecretQuesBloc, int?>(
                      builder: (_, int? state){
                        if(state == null){
                          return Text(
                            ATStrings.answerIsCaseSensitive,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: ATSizes.size11
                            ),
                          );
                        }
                        else if(state == 0){
                          return Text(
                            ATStrings.checker_loading,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: ATSizes.size11
                            ),
                          );
                        }
                        else if(state == 1){
                          return Text(
                            ATStrings.correctAnswer,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: ATSizes.size11,
                              color: ATColors.successColor
                            ),
                          );
                        }
                        else {
                          return Text(
                            ATStrings.INCORRECT_ANS,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: ATSizes.size11,
                              color: ATColors.textRedColor
                            ),
                          );
                        }
                        
                      }
                    ),
                  ],
                ),
              ),

              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
                child: BlocBuilder<_EnterSecretQuesBloc, int?>(
                  builder: (_, int? state){
                    return ATPlainElevatedBtn(
                      onPressed: state == 1 ? (){
                        context.pushNamed(
                          ATRoutes.paperPlaneSuccessScreen,
                          extra: <dynamic>[
                            'Withdrawal Request Sent',
                            TransactionType.withdraw,
                            "Your withdrawal request has been sent. We'll notify you once it is processed",
                          ]
                        );
                      } : null,
                      btnTitle: ATStrings.sendWithdrawalRequest
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
        builder: (_, int? state){
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
