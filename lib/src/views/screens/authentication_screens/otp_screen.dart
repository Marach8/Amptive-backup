
import 'package:amptive/src/bloc/authentication/otp/otp_auth_bloc.dart';
import 'package:amptive/src/bloc/authentication/otp/otp_auth_states.dart';
import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/common_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/authentication/otp/otp_auth_events.dart';
import '../../../utils/constants/font_weights.dart';
import '../../../utils/constants/strings/other_strings.dart';
import '../../../utils/constants/strings/route_strings.dart';
import '../../widgets/common_widgets/app_bar_widget.dart';
import '../../widgets/common_widgets/elevated_button_widget.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.from});

  final String from;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        backgroundColor: AmptiveColors.brandBlackColor,
        appBar: const AmptiveAppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  width: 297.w,
                  child: Text(
                    AmptiveHelperFunctions.enter4DigitSentFrom(widget.from.toLowerCase()),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: AmptiveFontSizes.size17
                    ),
                  ),
                ),
                SizedBox(height: 11.h,),
                Row(
                  children: [
                    OTPTextFormField(index: 0,),
                    SizedBox(width: 10.w,),
                    OTPTextFormField(index: 1),
                    SizedBox(width: 10.w,),
                    OTPTextFormField(index: 2),
                    SizedBox(width: 10.w,),
                    OTPTextFormField(index: 3),
                  ],
                ),
                BlocBuilder<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
                  buildWhen: (prev, curr) => curr is AmptiveOTPCounterState,
                  builder: (context, state) {
                    debugPrint(state.toString());
                    if (state is AmptiveOTPCounterState && state.timeLeft <= 0) {
                      _resendButtonEnabled = true;
                    }
                    if (state is AmptiveOTPCounterState) {
                      return Container(
                        margin: EdgeInsets.only(top: 11.h),
                        alignment: Alignment.centerLeft,
                        child: _resendButtonEnabled ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AmptiveOtherStrings.didNotGetCode,
                                style: Theme.of(context).textTheme.titleSmall
                              ),
                              TextSpan(
                                text: AmptiveOtherStrings.sendAgain,
                                recognizer: _tapGestureRecognizer,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: AmptiveFontWeights.regular,
                                  decorationColor: AmptiveColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        )
                        : Text(
                          AmptiveHelperFunctions.codeHasBeenSentResendIn(state.timeLeft),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      );
                    }
                    return Container();
                  }
                ),
                const Spacer()
                // Expanded(
                //   child: SizedBox(
                //     height: 1.h,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: BlocListener<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
            listener: (context, state) {
              if (state is VerifiedOTPAuthState && context.mounted) {
                context.pushReplacementNamed(AmptiveRoutes.passwordAuth);
              }
            },
            child: BlocBuilder<AmptiveOTPAuthBloc, AmptiveOTPAuthState>(
              buildWhen: (prev, curr) => curr is! AmptiveOTPCounterState,
              builder: (context, state) {
                return state is LoadingAuthState && context.mounted
                  ? const AmptiveLoadingButtonWidget()
                  : AmptiveElevatedButtonWidget(
                    height: 50.w,
                    buttonTitle: AmptiveOtherStrings.next,
                    onPressed: state is ValidOTPAuthState
                      ? () => context.read<AmptiveOTPAuthBloc>().add(VerifyOTPAuthEvent()) : null,
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OTPTextFormField extends StatelessWidget {
  OTPTextFormField({
    super.key,
    required this.index,
  });

  final int index;
  final OtpService service = GetIt.I<OtpService>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.w,
      width: 56.83.w,
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
        cursorColor: AmptiveColors.brandBlueColor,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          counterText: AmptiveOtherStrings.empty,
          label: const Center(
            child: Text(AmptiveOtherStrings.hyphen),
          ),
          labelStyle:Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: AmptiveFontWeights.regular,
        ),
          filled: true,
          fillColor: AmptiveColors.fillGreyColor.withOpacity(0.3),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.w,
              color: AmptiveColors.brandBlueColor,
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.w,
              color: AmptiveColors.transparentColor,
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        style:Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: AmptiveFontWeights.regular,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
