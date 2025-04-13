
import 'package:amptive/src/bloc/authentication/otp/otp_auth_bloc.dart';
import 'package:amptive/src/bloc/authentication/otp/otp_auth_states.dart';
import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/common_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/authentication/otp/otp_auth_events.dart';
import '../../../utils/constants/font_weights.dart';
import '../../../utils/constants/strings/other_strings.dart';
import '../../widgets/common_widgets/app_bar_widget.dart';
import '../../widgets/common_widgets/elevated_button_widget.dart';

class ATOTPScreen extends StatefulWidget {
  const ATOTPScreen({
    super.key,
    required this.emailOrPhone,
    required this.title
  });

  final String emailOrPhone, title;

  @override
  State<ATOTPScreen> createState() => _ATOTPScreenState();
}

class _ATOTPScreenState extends State<ATOTPScreen> {
  late TapGestureRecognizer _tapGestureRecognizer;
  // late Timer _timer;
  bool _resendButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    resetTimer(context);

    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () => resetTimer(context);
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  // void startTimer(BuildContext context) {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
  //     final currentState = BlocProvider.of<AmptiveOTPAuthBloc>(context).state;
  //
  //     if (currentState is AmptiveOTPCounterState) {
  //       int timeLeft = currentState.timeLeft;
  //
  //       if (timeLeft <= 1) {
  //         _resendButtonEnabled = true;
  //         _timer.cancel();
  //       }
  //
  //       context
  //           .read<AmptiveOTPAuthBloc>()
  //           .add(AmptiveOtpCountDownEvent(secondsLeft: timeLeft - 1));
  //     }
  //   });
  // }

  void resetTimer(BuildContext context) {
    context
        .read<AmptiveOTPAuthBloc>()
        .add(AmptiveOtpCountDownStartEvent());
    _resendButtonEnabled = false;

    // startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        backgroundColor: ATColors.brandBlack,
        appBar: ATAppBar(
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ATStrings.ENTER_CODE} ${widget.emailOrPhone}',
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: ATFontSizes.size17
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    _OTPTextFormField(index: 0,),
                    const SizedBox(width: 10,),
                    _OTPTextFormField(index: 1),
                    const SizedBox(width: 10,),
                    _OTPTextFormField(index: 2),
                    const SizedBox(width: 10,),
                    _OTPTextFormField(index: 3),
                  ],
                ),

                const SizedBox(height: 20),

                BlocBuilder<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
                  buildWhen: (prev, curr) => curr is AmptiveOTPCounterState,
                  builder: (context, state) {
                    debugPrint(state.toString());
                    if (state is AmptiveOTPCounterState && state.timeLeft <= 0) {
                      _resendButtonEnabled = true;
                    }
                    if (state is AmptiveOTPCounterState) {
                      return _resendButtonEnabled ? RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ATStrings.DID_NOT_GET_CODE,
                              style: Theme.of(context).textTheme.titleSmall
                            ),
                            TextSpan(
                              text: ATStrings.sendAgain,
                              recognizer: _tapGestureRecognizer,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: ATFontWeights.w400,
                                decorationColor: ATColors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                      : Text(
                        '${ATStrings.CODE_SENT} ${state.timeLeft}',
                        style: Theme.of(context).textTheme.titleSmall,
                      );
                    }
                    return Container();
                  }
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: BlocConsumer<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
            listener: (context, state) {
              if (state is VerifiedOTPAuthState && context.mounted) {
                //Remove this screen and the email input screen
                context.pop(); context.pop(true);
              }
            },
            buildWhen: (prev, curr) => curr is! AmptiveOTPCounterState,
            builder: (context, state) {
              return state is LoadingAuthState && context.mounted
                ? const AmptiveLoadingButtonWidget()
                : ATPlainElevatedBtn(
                  height: 50,
                  btnTitle: ATStrings.NEXT,
                  onPressed: state is ValidOTPAuthState
                    ? () => context.read<AmptiveOTPAuthBloc>().add(VerifyOTPAuthEvent()) : null,
                );
            },
          ),
        ),
      ),
    );
  }
}


class _OTPTextFormField extends StatelessWidget {
  _OTPTextFormField({required this.index});

  final int index;
  final OtpService service = GetIt.I<OtpService>();

  @override
  Widget build(context) {
    return SizedBox(
      height: 48,
      width: 56.83,
      child: TextFormField(
        autofocus: true,
        // textInputAction: TextInputAction.previous,
        onChanged: (value) {
          service.setOtp(value, index);
          // trigger otp changed event
          context
              .read<AmptiveOTPAuthBloc>()
              .add(OTPChangedAuthEvent(otpValid: service.isOTPValid));

          if (value.length == 1 && index != 3) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index != 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: ATColors.hex307FE2,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          counterText: ATStrings.empty,
          label: const Center(
            child: Text(ATStrings.hyphen),
          ),
          labelStyle:Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: ATFontWeights.w400,
        ),
          filled: true,
          fillColor: ATColors.hex9E9E9E.withOpacity(0.3),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: ATColors.hex307FE2,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: ATColors.trsprnt,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        style:Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: ATFontWeights.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
