import 'dart:async';

import 'package:amptive/src/bloc/authentication_bloc/auth_bloc.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_events.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_states.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'dart:developer' as marach show log;



class AmptiveVerifyOTPScreen extends StatefulWidget {
  const AmptiveVerifyOTPScreen({super.key,});

  @override
  State<AmptiveVerifyOTPScreen> createState() => _AmptiveVerifyOTPScreenState();
}

class _AmptiveVerifyOTPScreenState extends State<AmptiveVerifyOTPScreen> {
  late Timer _timer;
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = (){
      marach.log('Hello');
      AmptiveHelperFunctions.startTimer(
        timer: _timer,
        context: context
      );
    };
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: const AmptiveAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,           
              children: [
                Text(
                  AmptiveOtherStrings.enterTheCodeSentToYou,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                Gap(10.h),
                SizedBox(
                  width: AmptiveHelperFunctions.getScreenWidth(context) * 0.8,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: OTPTextField(
                      width: AmptiveHelperFunctions.getScreenWidth(context),
                      fieldStyle: FieldStyle.box,
                      onCompleted: (pin){
                        marach.log('This is the pin $pin');
                        context.read<AmptiveAuthBloc>().add(
                        OTPFieldIsCompletedAuthEvent(otpInputFromUser: pin)
                      );
                      },
                      fieldWidth: AmptiveHelperFunctions.getScreenWidth(context)/5,
                      contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5).r,
                      style: Theme.of(context).textTheme.displayMedium ?? const TextStyle(),
                      otpFieldStyle: OtpFieldStyle(
                        errorBorderColor: AmptiveColors.textRedColor,
                        backgroundColor: AmptiveColors.textFormFieldFillColor,
                        focusBorderColor: AmptiveColors.brandBlueColor,
                        enabledBorderColor: AmptiveColors.transparentColor,
                      ),
                    ),
                  ),
                ),

                Gap(10.h),
                BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                  builder: (_, state) {
                    final otpCountdown = state.resendOTPCountDown;
                    final timerNotStartedYet = otpCountdown == null;
                    final timerHasStarted = otpCountdown != null && otpCountdown != 0;
                    final timerHasFinished = otpCountdown == 0;
                    
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: AmptiveOtherStrings.didNotGetTheCode,
                            style: Theme.of(context).textTheme.titleSmall
                          ),
                          TextSpan(
                            text: AmptiveOtherStrings.sendAgain,
                            recognizer: _tapGestureRecognizer,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: AmptiveFontWeights.bold,
                              decorationColor: AmptiveColors.whiteColor,
                            ),
                          )
                        ]
                      )
                    );
                  }
                )
              ],
            ),
          ),
        ),

        bottomSheet: Padding(
          padding: const EdgeInsets.only(bottom: 20).r,
          child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
            buildWhen: (previous, current) => previous.otpInputFromUser != current.otpInputFromUser,
            builder: (_, state) {
              final noOTPFieldIsEmpty = state.otpInputFromUser != null;
              return AmptiveElevatedButtonWidget(
                buttonTitle: AmptiveOtherStrings.next,
                onPressed: noOTPFieldIsEmpty ? (){} : null
              );
            }
          ),
        ),
      ),
    );
  }
}







// import 'dart:async';

// import 'package:amptive/src/utils/constants/colors.dart';
// import 'package:amptive/src/views/widgets/common_widgets/app_bar.dart';
// import 'package:amptive/src/views/widgets/common_widgets/common_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loading_btn/loading_btn.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/form_providers.dart';
// import '../../../utils/constants/strings/route_strings.dart';


// int TIMER_LIMIT = 10;

// class OTPScreen extends StatefulWidget {
//   const OTPScreen({super.key, required this.from});

//   final String from;

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   late FormProvider _formProvider;
//   int _start = TIMER_LIMIT;
//   late Timer _timer;
//   bool _resendButtonEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//       if (_start == 0) {
//         setState(() {
//           _resendButtonEnabled = true;
//           _timer.cancel();
//         });
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }

//   void resetTimer() {
//     setState(() {
//       _start = TIMER_LIMIT;
//       _resendButtonEnabled = false;
//     });
//     startTimer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _formProvider = Provider.of<FormProvider>(context);

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AmptiveColors.brandBlackColor,
//         appBar: const AmptiveAppBar(),
//         body: Container(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(top: 20.h),
//                   width: 297.w,
//                   child: Text(
//                     "Enter the 4 digit code we just sent to your ${widget.from}",
//                     textAlign: TextAlign.start,
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 17.sp,
//                       color: AmptiveColors.whiteColor,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 11.h,
//                 ),
//                 Row(
//                   children: [
//                     OTPTextFormField(
//                       index: 0,
//                       provider: _formProvider,
//                     ),
//                     SizedBox(
//                       width: 10.w,
//                     ),
//                     OTPTextFormField(index: 1, provider: _formProvider),
//                     SizedBox(
//                       width: 10.w,
//                     ),
//                     OTPTextFormField(index: 2, provider: _formProvider),
//                     SizedBox(
//                       width: 10.w,
//                     ),
//                     OTPTextFormField(index: 3, provider: _formProvider),
//                   ],
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 11.h),
//                   alignment: Alignment.centerLeft,
//                   child: _resendButtonEnabled
//                       ? RichText(
//                           text: TextSpan(
//                             text: "Didn't get the code? ",
//                             children: [
//                               WidgetSpan(
//                                 child: GestureDetector(
//                                   onTap: (){
//                                     resetTimer();
//                                   },
//                                   child: Text(
//                                     "Send again",
//                                     style: GoogleFonts.inter(
//                                       decoration: TextDecoration.underline,
//                                       decorationColor: AmptiveColors.whiteColor,
//                                       fontSize: 12.sp,
//                                       color: AmptiveColors.whiteColor,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                             style: GoogleFonts.inter(
//                               fontSize: 12.sp,
//                               color: AmptiveColors.whiteColor,
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         )
//                       : Text(
//                           "Code has been sent. You can send another in $_start",
//                           style: GoogleFonts.inter(
//                             fontSize: 12.sp,
//                             color: AmptiveColors.whiteColor,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                 ),
//                 Expanded(
//                   child: SizedBox(
//                     height: 1.h,
//                   ),
//                 ),
//                 Consumer<FormProvider>(builder: (context, model, _) {
//                   return Container(
//                     margin: EdgeInsets.only(bottom: 29.h),
//                     child: CustomLoaderButton(
//                         width: 350.w,
//                         height: 50.w,
//                         borderRadius: 100.r,
//                         onTap: (start, stop, state) async {
//                           // Validate returns true if the form is valid, or false otherwise.
//                           if (state == ButtonState.idle) {
//                             start();
//                             if (model.isOTPValid) {
//                               context.pushNamed(AmptiveRoutes.passwordAuth);
//                             }
//                             stop();
//                           }
//                         },
//                         validCondition: model.isOTPValid,
//                         childText: "Next"),
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OTPTextFormField extends StatelessWidget {
//   const OTPTextFormField({
//     super.key,
//     required this.provider,
//     required this.index,
//   });

//   final int index;
//   final FormProvider provider;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 48.w,
//       width: 56.83.w,
//       child: TextFormField(
//         autofocus: true,
//         // textInputAction: TextInputAction.previous,
//         onChanged: (value) {
//           provider.setOtp(value, index);
//           if (value.length == 1 && index != 3) {
//             FocusScope.of(context).nextFocus();
//           } else if (value.isEmpty && index != 0) {
//             FocusScope.of(context).previousFocus();
//           }
//         },
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         textAlignVertical: TextAlignVertical.center,
//         cursorColor: AmptiveColors.brandBlueColor,
//         decoration: InputDecoration(
//           contentPadding:
//               EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
//           floatingLabelBehavior: FloatingLabelBehavior.never,
//           counterText: "",
//           label: const Center(
//             child: Text("-"),
//           ),
//           labelStyle: GoogleFonts.inter(
//             fontSize: 18.sp,
//             color: AmptiveColors.authHintColor,
//             fontWeight: FontWeight.normal,
//           ),

//           filled: true,
//           fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 2.w,
//               color: AmptiveColors.brandBlueColor,
//             ),
//             borderRadius: BorderRadius.circular(14.r),
//           ),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 2.w,
//               color: AmptiveColors.transparentColor,
//             ),
//             borderRadius: BorderRadius.circular(14.r),
//           ),
//         ),
//         style: GoogleFonts.inter(
//           fontWeight: FontWeight.normal,
//           fontSize: 18.sp,
//           color: AmptiveColors.whiteColor,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
