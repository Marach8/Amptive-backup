import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/features/auth/cubits/password_reset_otp_cubit.dart';
import 'package:amptive/src/features/auth/cubits/verify_reset_password_otp_cubit.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/otp_fields_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/single_child_widget.dart';
import '../../../../config/utils/font_weights.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../shared/app_bar_widget.dart';
import '../../../../shared/elevated_button_widget.dart';

enum OTPVerificationType { email, phoneNumber }

class VerifyPasswordResetOTPScreenParams {
  const VerifyPasswordResetOTPScreenParams({
    required this.identifier,
    required this.verificationType,
    this.title,
    this.otp,
  });

  final String identifier;
  final String? title, otp;
  final OTPVerificationType verificationType;
}

class ResetPasswordOtpScreen extends StatefulWidget {
  const ResetPasswordOtpScreen({
    super.key,
    required this.params,
  });
  final VerifyPasswordResetOTPScreenParams params;

  @override
  State<ResetPasswordOtpScreen> createState() => _ResetPasswordOtpScreenState();
}

class _ResetPasswordOtpScreenState extends State<ResetPasswordOtpScreen> {
  final ValueNotifier<({bool otpcorrect, bool notresendingotp})>
      activateBtnNotifier =
      ValueNotifier<({bool otpcorrect, bool notresendingotp})>(
          (otpcorrect: false, notresendingotp: true));
  final ValueNotifier<bool> didSendAgainNotifier = ValueNotifier<bool>(false);
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  final int countDownStart = 10;

  String? _matchingOtp;

  Stream<int> generateCountDown() async* {
    for (int i = countDownStart; i >= 0; i--) {
      yield i;
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    didSendAgainNotifier.value = false;
  }

  @override
  void initState() {
    super.initState();
    _matchingOtp = widget.params.otp;
  }

  @override
  void dispose() {
    activateBtnNotifier.dispose();
    didSendAgainNotifier.dispose();
    _tapGestureRecognizer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String identifierKey = '';
    switch (widget.params.verificationType) {
      case OTPVerificationType.email:
        identifierKey = 'email';
        break;
      case OTPVerificationType.phoneNumber:
        identifierKey = 'phone_number';
        break;
    }

    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<VerifyResetPasswordOtpCubit>(
            create: (_) => VerifyResetPasswordOtpCubit()),
        BlocProvider<PasswordResetOtpCubit>(
            create: (_) => PasswordResetOtpCubit()),
      ],
      child: ATAnnotatedRegion(
        child: Scaffold(
          backgroundColor: ATColors.hex0D0D0D,
          appBar: ATAppBar(
            titleText: widget.params.title,
            leading: const ATBackBtn(),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BlocListener<PasswordResetOtpCubit, ATAppState<String>>(
                    listener: (_, ATAppState<String> sendOtpState) {
                      final ({
                        bool notresendingotp,
                        bool otpcorrect
                      }) currentState = activateBtnNotifier.value;
                      if (sendOtpState is LoadingState<String>) {
                        activateBtnNotifier.value = (
                          otpcorrect: currentState.otpcorrect,
                          notresendingotp: false
                        );
                      } else {
                        activateBtnNotifier.value = (
                          otpcorrect: currentState.otpcorrect,
                          notresendingotp: true
                        );
                      }
                    },
                    child: Text(
                      '${ATStrings.enterCodeSentTo} ${widget.params.identifier}',
                      maxLines: 2,
                      style: context.textTheme.headlineMedium
                          ?.copyWith(fontSize: ATSizes.size17),
                    ),
                  ),
                  const SizedBox(height: 11),
                  ATOTPFieldsWidget(
                    onPinComplete: (String pin) async {
                      final bool isCorrect = pin == _matchingOtp;
                      final ({
                        bool notresendingotp,
                        bool otpcorrect
                      }) currentState = activateBtnNotifier.value;
                      activateBtnNotifier.value = (
                        otpcorrect: isCorrect,
                        notresendingotp: currentState.notresendingotp
                      );
                      return isCorrect;
                    },
                  ),
                  const SizedBox(height: 11),
                  ValueListenableBuilder<bool>(
                      valueListenable: didSendAgainNotifier,
                      builder: (BuildContext context, bool didSendAgain, __) {
                        if (didSendAgain) {
                          return StreamBuilder<int>(
                              stream: generateCountDown(),
                              initialData: 10,
                              builder: (_, AsyncSnapshot<int> asyncSnapshot) {
                                final int timeLeft = asyncSnapshot.data!;
                                return Text(
                                  maxLines: 2,
                                  '${ATStrings.codeHasBeenSent} $timeLeft ${timeLeft == 1 ? 'second' : 'seconds'}',
                                  style: context.textTheme.titleSmall,
                                );
                              });
                        }
                        return RichText(
                          text: TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                  text: ATStrings.didNotGetCode,
                                  style: context.textTheme.titleSmall),
                              TextSpan(
                                text: ATStrings.sendAgain,
                                recognizer: _tapGestureRecognizer
                                  ..onTap = () {
                                    context
                                        .read<PasswordResetOtpCubit>()
                                        .resetPasswordOtp(
                                            param: <String, dynamic>{
                                          identifierKey:
                                              widget.params.identifier
                                        });
                                    didSendAgainNotifier.value = true;
                                  },
                                style: context.textTheme.titleSmall?.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: ATFontWeights.w400,
                                  decorationColor: ATColors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          bottomSheet: Builder(builder: (BuildContext context) {
            final double bottom = MediaQuery.viewInsetsOf(context).bottom;
            final double bottomPadding = bottom > 0 ? 10 : 50;
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPadding),
              child: ValueListenableBuilder<
                      ({bool otpcorrect, bool notresendingotp})>(
                  valueListenable: activateBtnNotifier,
                  builder:
                      (_, ({bool otpcorrect, bool notresendingotp}) state, __) {
                    final bool shouldEnable =
                        state.otpcorrect && state.notresendingotp;
                    return BlocConsumer<VerifyResetPasswordOtpCubit,
                        ATAppState<dynamic>>(
                      listener: (_, ATAppState<dynamic> state) {
                        if (state is SuccessState<dynamic>) {
                          context.pop(true);
                        } else if (state is FailureState<dynamic>) {
                          showAppNotification2(
                            context: context,
                            text: state.message,
                            type: NotificationType.failure,
                          );
                        }
                      },
                      builder: (BuildContext context,
                          ATAppState<dynamic> verifyOtpState) {
                        return ATPlainElevatedBtn(
                          isLoading: verifyOtpState is LoadingState<dynamic>,
                          onPressed: shouldEnable
                              ? () {
                                  context
                                      .read<VerifyResetPasswordOtpCubit>()
                                      .verifyResetPasswordOtp(
                                    param: <String, dynamic>{
                                      identifierKey: widget.params.identifier,
                                      'otp': _matchingOtp,
                                    },
                                  );
                                }
                              : null,
                          btnTitle: ATStrings.next,
                        );
                      },
                    );
                  }),
            );
          }),
        ),
      ),
    );
  }
}
