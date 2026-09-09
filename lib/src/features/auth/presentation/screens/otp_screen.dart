import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/cubits/send_otp_cubit.dart';
import 'package:amptive/src/features/auth/cubits/verify_otp_cubit.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
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

class VerifyOTPScreenParams {
  const VerifyOTPScreenParams({
    required this.dataToVerify,
    required this.verificationType,
    this.appbarTitle,
  });

  final String dataToVerify;
  final String? appbarTitle;
  final OTPVerificationType verificationType;
}

typedef ActivateNextBtnParams = ({bool pinIsComplete, bool isResendingOtp});

class ATOTPScreen extends StatefulWidget {
  const ATOTPScreen({
    super.key,
    required this.params,
  });
  final VerifyOTPScreenParams params;

  @override
  State<ATOTPScreen> createState() => _ATOTPScreenState();
}

class _ATOTPScreenState extends State<ATOTPScreen> {
  final ValueNotifier<ActivateNextBtnParams> activateBtnNotifier =
      ValueNotifier<ActivateNextBtnParams>(
          (pinIsComplete: false, isResendingOtp: false));
  final ValueNotifier<bool> didSendAgainNotifier = ValueNotifier<bool>(false);
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  final int countDownStart = 10;
  String _otp = '';

  Stream<int> generateCountDown() async* {
    for (int i = countDownStart; i >= 0; i--) {
      yield i;
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    didSendAgainNotifier.value = false;
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
        BlocProvider<VerifyOtpCubit>(create: (_) => VerifyOtpCubit()),
        BlocProvider<SendOtpCubit>(create: (_) => SendOtpCubit()),
      ],
      child: ATAnnotatedRegion(
        child: Scaffold(
          backgroundColor: ATColors.hex0D0D0D,
          appBar: ATAppBar(
            titleText: widget.params.appbarTitle,
            leading: const ATBackBtn(),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Listener for resending otp
                  BlocListener<SendOtpCubit, ATAppState<String>>(
                    listener: (_, ATAppState<String> sendOtpState) {
                      activateBtnNotifier.value = (
                        pinIsComplete: activateBtnNotifier.value.pinIsComplete,
                        isResendingOtp: sendOtpState is LoadingState<String>
                      );
                    },
                    child: Text(
                      '${ATStrings.enterCodeSentTo} ${widget.params.dataToVerify}',
                      maxLines: 2,
                      style: context.textTheme.headlineMedium
                          ?.copyWith(fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 11),
                  ATOTPFieldsWidget(
                    onPinFieldChanged: (_) {
                      activateBtnNotifier.value = (
                        pinIsComplete: false,
                        isResendingOtp: activateBtnNotifier.value.isResendingOtp,
                      );
                    },
                    onPinComplete: (String pin) async {
                      final bool otpIsCorrect = pin.length == 4;
                      _otp = pin;
                      activateBtnNotifier.value = (
                        pinIsComplete: otpIsCorrect,
                        isResendingOtp: activateBtnNotifier.value.isResendingOtp,
                      );
                      return otpIsCorrect;
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
                                        .read<SendOtpCubit>()
                                        .sendOtp(param: <String, dynamic>{
                                      identifierKey: widget.params.dataToVerify
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

          bottomSheet: Builder(
            builder: (BuildContext context) {
              final double bottom = MediaQuery.viewInsetsOf(context).bottom;
              final double bottomPadding = bottom > 0 ? 10 : 50;
              return Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPadding),
                child: ValueListenableBuilder<
                        ({bool pinIsComplete, bool isResendingOtp})>(
                    valueListenable: activateBtnNotifier,
                    builder: (_,
                        ({bool pinIsComplete, bool isResendingOtp}) state, __) {
                      final bool shouldEnable =
                          state.pinIsComplete && !state.isResendingOtp;
                      return BlocConsumer<VerifyOtpCubit, ATAppState<dynamic>>(
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
                                    context.read<VerifyOtpCubit>().verifyOtp(
                                      param: <String, dynamic>{
                                        identifierKey: widget.params.dataToVerify,
                                        'otp': _otp
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
            }
          ),
        ),
      ),
    );
  }
}
