import 'package:amptive/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:provider/provider.dart';

import '../providers/form_providers.dart';
import '../routers/amptive_routes.dart';
import '../utils/utils.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late FormProvider _formProvider;

  @override
  Widget build(BuildContext context) {
    _formProvider = Provider.of<FormProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
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
                    "Enter the 4 digit code we just sent to your email",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.sp,
                      color: AmpColors.white,
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
                      provider: _formProvider,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    OTPTextFormField(index: 1, provider: _formProvider),
                    SizedBox(
                      width: 10.w,
                    ),
                    OTPTextFormField(index: 2, provider: _formProvider),
                    SizedBox(
                      width: 10.w,
                    ),
                    OTPTextFormField(index: 3, provider: _formProvider),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 11.h),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't get the code? ",
                      children: [
                        TextSpan(
                          text: "Send again",
                          style: GoogleFonts.inter(
                              decoration: TextDecoration.underline),
                        )
                      ],
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AmpColors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 1.h,
                  ),
                ),
                Consumer<FormProvider>(builder: (context, model, _) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 29.h),
                    child: CustomLoaderButton(
                        width: 350.w,
                        height: 50.w,
                        borderRadius: 100.r,
                        onTap: (start, stop, state) async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (state == ButtonState.idle) {
                            start();
                            if (model.isOTPValid) {
                              context.pushNamed(AmptiveRoutes.passwordAuth);
                            }
                            stop();
                          }
                        },
                        validCondition: model.isOTPValid,
                        childText: "Next"),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OTPTextFormField extends StatelessWidget {
  const OTPTextFormField({
    super.key,
    required this.provider,
    required this.index,
  });

  final int index;
  final FormProvider provider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.w,
      width: 56.83.w,
      child: TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.previous,
        onChanged: (value) {
          provider.setOtp(value, index);
          if (value.length == 1 && index != 3) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index != 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          counterText: "",
          label: const Center(
            child: Text("-"),
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: 16.sp,
            color: AmpColors.authHintColor,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.w,
              color: AmpColors.brandBlue,
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.w,
              color: AmpColors.transparent,
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        style: GoogleFonts.inter(
            fontWeight: FontWeight.normal,
            fontSize: 16.sp,
            color: AmpColors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
