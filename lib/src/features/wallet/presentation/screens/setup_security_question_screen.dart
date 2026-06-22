import 'package:amptive/src/config/api_response_and_app_state.dart';

import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';

import 'package:amptive/src/config/utils/colors.dart';

import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';

import 'package:amptive/src/config/utils/extensions/context_extensions.dart';

import 'package:amptive/src/config/utils/other_strings.dart';

import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';

import 'package:amptive/src/features/wallet/cubits/security_questions_cubit.dart';

import 'package:amptive/src/features/wallet/cubits/set_pin_cubit.dart';

import 'package:amptive/src/features/wallet/data/models/request/set_pin_request.dart';
import 'package:amptive/src/features/wallet/data/models/response/security_questions_response_model.dart';

import 'package:amptive/src/features/wallet/presentation/widgets/security_question.dialog.dart';

import 'package:amptive/src/config/utils/helper_functions.dart';

import 'package:amptive/src/shared/annotated_region_widget.dart';

import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';

import 'package:amptive/src/shared/app_bar_widget.dart';

import 'package:amptive/src/shared/back_button.dart';

import 'package:amptive/src/shared/custom_container_widget.dart';

import 'package:amptive/src/shared/elevated_button_widget.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:amptive/src/shared/textformfield_widget.dart';

import '../../bloc/security_question_bloc.dart';

class ATSecurityQuestionScreen extends StatelessWidget {
  const ATSecurityQuestionScreen({super.key});

  // static const List<String> items = <String>[

  //   'What is your mother\'s maiden name?',

  //   'What was the name of your first pet?',

  //   'What is the name of your favorite teacher in high school?',

  //   'In what city were you born?',

  //   'What is your childhood nickname?',

  //   'What is the name of your first school?'

  // ];

  @override
  Widget build(_) {
    return ATAnnotatedRegion(
        child: MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<SecQuestionBloc>(
          create: (_) => SecQuestionBloc(),
        ),
        BlocProvider<SetPinCubit>(
          create: (_) => SetPinCubit(),
        ),
        BlocProvider<WalletSecurityQuestionsCubit>(
          create: (_) =>
              WalletSecurityQuestionsCubit()..fetchSecurityQuestions(),
        )
      ],
      child: Builder(builder: (BuildContext context) {
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
              children: <Widget>[
                Text(ATStrings.SELECT_SECURITY_QUEST,
                    style: context.textTheme.bodyMedium),
                const SizedBox(
                  height: 10,
                ),
                BlocConsumer<WalletSecurityQuestionsCubit,
                    ATAppState<SecurityQuestionsResponseModel>>(
                  listener: (BuildContext context,
                      ATAppState<SecurityQuestionsResponseModel> state) {
                    if (state is FailureState<SecurityQuestionsResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context,
                      ATAppState<SecurityQuestionsResponseModel> state) {
                    return switch (state) {
                      InitialState<SecurityQuestionsResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<SecurityQuestionsResponseModel>() ||
                      FailureState<SecurityQuestionsResponseModel>() ||
                      SuccessState<SecurityQuestionsResponseModel>() =>
                        Builder(builder: (BuildContext context) {
                          final SecurityQuestionsResponseModel? questionsModel =
                              context
                                  .read<WalletSecurityQuestionsCubit>()
                                  .currentSecurityQuestions;
                          final List<String> questions =
                              questionsModel?.data?.securityQuestions ??
                                  <String>[];

                          // if (questions.isEmpty) {
                          //   // if (state is LoadingState<SecurityQuestionsResponseModel>) {
                          //   //   return const CircularProgressIndicator();
                          //   // }
                          //   if (state is FailureState<
                          //       SecurityQuestionsResponseModel>) {
                          //     return Center(
                          //       child: IconButton(
                          //         icon: const Icon(Icons.refresh),
                          //         onPressed: () => context
                          //             .read<WalletSecurityQuestionsCubit>()
                          //             .fetchSecurityQuestions(),
                          //       ),
                          //     );
                          //   }
                          //   return const Center(
                          //     child: Text('No security questions available'),
                          //   );
                          // }

                          return ATContainer(
                            onTap: state is LoadingState<
                                    SecurityQuestionsResponseModel>
                                ? null
                                : () async {
                                    context
                                        .read<SecQuestionBloc>()
                                        .toggleIcon();

                                    final String? result =
                                        await showSecurityQuestionsDialog(
                                      context: context,
                                      items: questions,
                                    );
                                    if (result != null && context.mounted) {
                                      context
                                          .read<SecQuestionBloc>()
                                          .setSecQuestion(result);
                                    }
                                    if (context.mounted) {
                                      context
                                          .read<SecQuestionBloc>()
                                          .toggleIcon();
                                    }
                                  },
                            color: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                            radius: 14,
                            width: context.screenWidth,
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: Row(
                              children: <Widget>[
                                BlocSelector<SecQuestionBloc,
                                    (String?, bool, String), String?>(
                                  selector: ((String?, bool, String) state) =>
                                      state.$1,
                                  builder: (_, String? state) {
                                    return Expanded(
                                      child: Text(
                                        state ??
                                            ATStrings.aQuestionYouCanRemember,
                                        maxLines: 3,
                                        style: context.textTheme.labelMedium
                                            ?.copyWith(
                                          color: state == null
                                              ? ATColors.hex5B5B5B
                                              : ATColors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 20),
                                state is LoadingState<
                                        SecurityQuestionsResponseModel>
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2))
                                    : BlocSelector<SecQuestionBloc,
                                        (String?, bool, String), bool>(
                                        selector:
                                            ((String?, bool, String) state) =>
                                                state.$2,
                                        builder: (_, bool state) {
                                          return Icon(
                                            state
                                                ? Icons
                                                    .keyboard_arrow_up_rounded
                                                : Icons
                                                    .keyboard_arrow_down_rounded,
                                            size: 30,
                                          );
                                        },
                                      ),
                              ],
                            ),
                          );
                        }),
                    };
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocSelector<SecQuestionBloc, (String?, bool, String), String?>(
                    selector: ((String?, bool, String) state) => state.$1,
                    builder: (_, String? state) {
                      return ATAnimatedXFade(
                        condition: state == null,
                        firstChild: const SizedBox.shrink(),
                        secondChild: const SecurityAnswerField(),
                      );
                    })
              ],
            ),
          ),
          bottomSheet: BlocConsumer<SetPinCubit, ATAppState<dynamic>>(
              listener: (_, ATAppState<dynamic> state) async {
            if (state is SuccessState<dynamic>) {
              final FlutterSecureStorageServiceImpl storage =
                  FlutterSecureStorageServiceImpl();

              await storage.set(ATStrings.hasSetWalletPin, 'true');
                await context.read<LocalUserDataCubit>().refreshWalletPinStatus();



              context.goNamed(ATRoutes.walletCreationAnimationScreen);
            }

            if (state is FailureState<dynamic>) {
              showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure);
            }
          }, builder: (BuildContext context, ATAppState<dynamic> state) {
            final (String? question, bool _, String answer) =
                context.read<SecQuestionBloc>().state;

            final double bottom = MediaQuery.viewInsetsOf(context).bottom;

            final double bottomPadd = bottom == 0 ? 50 : 15;

            return Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPadd),
              child: ATPlainElevatedBtn(
                  btnTitle: ATStrings.FINISH_SETUP,
                  isLoading: state is LoadingState<dynamic>,
                  onPressed: () {
                    final (String?, bool, String) currentState =
                        context.read<SecQuestionBloc>().state;

                    final String? question = currentState.$1;

                    final String answer = currentState.$3;

                    SetPinData().copyWith(
                      securityQuestion: question,
                      securityQuestionAnswer: answer,
                    );

                    context.read<SetPinCubit>().setPin(
                          param: SetPinData(),
                        );
                  }),
            );
          }),
        );
      }),
    ));
  }
}

class SecurityAnswerField extends StatelessWidget {
  const SecurityAnswerField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(ATStrings.WHAT_IS_UR_ANSWER, style: context.textTheme.bodyMedium),
        const SizedBox(
          height: 10,
        ),
        ATTextFormField(
          hintText: ATStrings.enterYourAnswer,
          prefixIcon: const SizedBox(
            width: 12,
          ),
          maxLines: 1,
          fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
          onChanged: (String text) {
            ATHelperFuncs.callDebouncer(
                1000, () => context.read<SecQuestionBloc>().setSecAnswer(text));
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Text(ATStrings.answerIsCaseSensitive,
            style: context.textTheme.titleSmall),
        const SizedBox(
          height: 10,
        ),
        Text(ATStrings.U_MUST_ANS_SECURITY_QUEST,
            maxLines: 2, style: context.textTheme.titleSmall),
      ],
    );
  }
}
