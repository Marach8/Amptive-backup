import 'dart:async';

import 'package:amptive/src/bloc/authentication_bloc/auth_events.dart';
import 'package:amptive/src/services/auth/otp_service.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar.dart';
import 'package:amptive/src/views/widgets/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/authentication_bloc/auth_bloc.dart';
import '../../../bloc/authentication_bloc/auth_states.dart';
import '../../../utils/constants/strings/other_strings.dart';
import '../../../utils/constants/strings/route_strings.dart';
import '../../widgets/common_widgets/elevated_button_widget.dart';

int TIMER_LIMIT = 10;

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.from});

  final String from;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  int _start = TIMER_LIMIT;
  late Timer _timer;
  bool _resendButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          _resendButtonEnabled = true;
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resetTimer() {
    setState(() {
      _start = TIMER_LIMIT;
      _resendButtonEnabled = false;
    });
    startTimer();
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
                    "Enter the 4 digit code we just sent to your ${widget.from}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.sp,
                      color: AmptiveColors.whiteColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                Row(
                  children: [
                    OTPTextFormField(
                      index: 0,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    OTPTextFormField(index: 1),
                    SizedBox(
                      width: 10.w,
                    ),
                    OTPTextFormField(index: 2),
                    SizedBox(
                      width: 10.w,
                    ),
                    OTPTextFormField(index: 3),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 11.h),
                  alignment: Alignment.centerLeft,
                  child: _resendButtonEnabled
                      ? RichText(
                          text: TextSpan(
                            text: "Didn't get the code? ",
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    resetTimer();
                                  },
                                  child: Text(
                                    "Send again",
                                    style: GoogleFonts.inter(
                                      decoration: TextDecoration.underline,
                                      decorationColor: AmptiveColors.whiteColor,
                                      fontSize: 12.sp,
                                      color: AmptiveColors.whiteColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              )
                            ],
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AmptiveColors.whiteColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      : Text(
                          "Code has been sent. You can send another in $_start",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AmptiveColors.whiteColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 1.h,
                  ),
                ),
                BlocListener<AmptiveAuthBloc, AmptiveAuthState>(
                  listener: (context, state) {
                    if (state is ValidAuthState && context.mounted) {
                      context.pushNamed(AmptiveRoutes.passwordAuth);
                    }
                  },
                  child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                      builder: (context, state) {
                    return state is LoadingAuthState && context.mounted
                        ? AmptiveLoadingButtonWidget(
                            margin: EdgeInsets.only(bottom: 29.h),
                          )
                        : AmptiveElevatedButtonWidget(
                            margin: EdgeInsets.only(bottom: 29.h),
                            height: 50.w,
                            buttonTitle: AmptiveOtherStrings.next,
                            onPressed: state is ValidOTPAuthState
                                ? () {
                                    context
                                        .read<AmptiveAuthBloc>()
                                        .add(VerifyOTPAuthEvent());
                                  }
                                : null,
                          );
                  }),
                ),
              ],
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
              .read<AmptiveAuthBloc>()
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
          counterText: "",
          label: const Center(
            child: Text("-"),
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: 18.sp,
            color: AmptiveColors.authHintColor,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
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
        style: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          fontSize: 18.sp,
          color: AmptiveColors.whiteColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
