import 'dart:async';

import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/authentication/general/auth_bloc.dart';
import '../../../bloc/authentication/general/auth_states.dart';

class UserNameAuthScreen extends StatefulWidget {
  const UserNameAuthScreen({super.key});

  @override
  State<UserNameAuthScreen> createState() => _UserNameAuthScreenState();
}

class _UserNameAuthScreenState extends State<UserNameAuthScreen> {
  late final AuthFieldService service;

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
  void initState() {
    service = GetIt.I<AuthFieldService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AmptiveColors.brandBlackColor,
        appBar: const AmptiveAppBar(),
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
                      await service.validateUsername(val);
                      setLoading(false);
                    });
                  },
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  cursorColor: service.username.error == null
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
                        : service.isUsernameValid
                            ? Container(
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                child: Icon(
                                  Icons.check,
                                  color: AmptiveColors.successColor,
                                ),
                              )
                            : service.isUsernameInvalid
                                ? Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    child: Icon(
                                      Icons.close,
                                      color: AmptiveColors.textRedColor,
                                    ),
                                  )
                                : null,
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
                        color: service.username.error == null
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
                  visible: !_isLoading && service.isUsernameValid,
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
                  visible: !_isLoading && !service.isUsernameValid,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      service.username.error ?? "",
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
                BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                    builder: (context, state) {
                  return Container(
                    width: 350.w,
                    height: 50.w,
                    margin: EdgeInsets.only(bottom: 29.h),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (service.isUsernameValid) {
                          context.goNamed(AmptiveRoutes.addName);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: service.isUsernameValid
                              ? AmptiveColors.brandBlueColor
                              : const Color(0xFF2F2F2F)),
                      child: Text(
                        AmptiveOtherStrings.next,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: service.isUsernameValid
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
