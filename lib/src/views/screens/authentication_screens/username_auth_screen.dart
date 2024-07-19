import 'dart:async';

import 'package:amptive/src/providers/form_providers.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class UserNameAuthScreen extends StatefulWidget {
  const UserNameAuthScreen({super.key});

  @override
  State<UserNameAuthScreen> createState() => _UserNameAuthScreenState();
}

class _UserNameAuthScreenState extends State<UserNameAuthScreen> {
  late FormProvider _formProvider;

  TextEditingController usernameController = TextEditingController();
  Timer? _typingTimer;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  setLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    _formProvider = Provider.of<FormProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AmptiveColors.brandBlackColor,
        appBar: const BuildAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What should we call you?",
                  style: GoogleFonts.inter(
                    color: AmptiveColors.whiteColor,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                TextFormField(
                  controller: usernameController,
                  onChanged: (val) {
                    if (_typingTimer?.isActive ?? false) {
                      setLoading(false);
                      _typingTimer!.cancel();
                    }
                    _typingTimer = Timer(const Duration(seconds: 1), () async {
                      setLoading(true);
                      await _formProvider.validateUsername(val);
                      setLoading(false);
                    });
                  },
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  cursorColor: _formProvider.username.error == null
                      ? AmptiveColors.brandBlueColor
                      : AmptiveColors.textRedColor,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    prefixIcon: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 16.w),
                      child: Text(
                        "@",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: AmptiveColors.whiteColor,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    suffix: _isLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: AmptiveColors.brandBlueColor,
                              backgroundColor:
                                  AmptiveColors.brandBlueColor.withOpacity(0.5),
                              strokeWidth: 3.w,
                            ),
                          )
                        : null,
                    suffixIcon: _isLoading
                        ? null
                        : _formProvider.isUsernameValid
                            ? Container(
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                child: Icon(
                                  Icons.check,
                                  color: AmptiveColors.successColor,
                                ),
                              )
                            : _formProvider.isUsernameInvalid? Container(
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                child: Icon(
                                  Icons.close,
                                  color: AmptiveColors.textRedColor,
                                ),
                              ): null,
                    hintText: "username",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AmptiveColors.authHintColor,
                      fontWeight: FontWeight.normal,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: _formProvider.username.error == null
                            ? AmptiveColors.brandBlueColor
                            : AmptiveColors.textRedColor,
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
                      fontSize: 16.sp,
                      color: AmptiveColors.whiteColor),
                ),
                Visibility(
                  visible: _isLoading,
                  child: Container(
                    height: 20.h,
                    margin: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      "Checker is loading...",
                      style: GoogleFonts.inter(
                        color: AmptiveColors.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        height: 0.14,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !_isLoading && _formProvider.isUsernameValid,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      "Username is available",
                      style: GoogleFonts.inter(
                        color: AmptiveColors.successColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 11.sp,
                        height: 0.14,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !_isLoading && !_formProvider.isUsernameValid,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      _formProvider.username.error ?? "",
                      style: GoogleFonts.inter(
                        color: AmptiveColors.textRedColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 11.sp,
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
                    width: 350.w,
                    height: 50.w,
                    margin: EdgeInsets.only(bottom: 29.h),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (model.isUsernameValid) {
                          context.goNamed(AmptiveRoutes.addName);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: model.isUsernameValid
                              ? AmptiveColors.brandBlueColor
                              : const Color(0xFF2F2F2F)),
                      child: Text(
                        "Next",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: model.isUsernameValid
                                ? AmptiveColors.whiteColor
                                : const Color(0xFF666666)),
                      ),
                    ),
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
