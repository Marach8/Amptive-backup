import 'package:amptive/src/bloc/authentication_bloc/auth_bloc.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_states.dart';
import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/authentication_bloc/auth_events.dart';
import '../../../utils/constants/strings/other_strings.dart';
import '../../widgets/common_widgets/elevated_button_widget.dart';

class PasswordAuthScreen extends StatefulWidget {
  const PasswordAuthScreen({super.key});

  @override
  State<PasswordAuthScreen> createState() => _PasswordAuthScreenState();
}

class _PasswordAuthScreenState extends State<PasswordAuthScreen> {
  bool _passwordVisible = false;
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var service = GetIt.I<AuthFieldService>();

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
                  "Create a password for your account",
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
                  controller: passwordController,
                  onChanged: (value) {
                    service.validatePassword(value);

                    // trigger password changed event
                    context
                        .read<AmptiveAuthBloc>()
                        .add(PasswordChangedAuthEvent());
                  },
                  maxLines: 1,
                  obscureText: !_passwordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: AmptiveColors.brandBlueColor,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 16.w),
                      hintText: "Enter your password",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: AmptiveColors.authHintColor,
                        fontWeight: FontWeight.normal,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                      focusedBorder: buildOutlineInputBorder(),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.w,
                          color: AmptiveColors.transparentColor,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      suffixIcon: IconButton(
                        icon: Padding(
                          padding: EdgeInsets.only(right: 16.0.w),
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AmptiveColors.whiteColor,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      )),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.sp,
                    color: AmptiveColors.whiteColor,
                  ),
                ),
                BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                    builder: (_, state) {
                  var height = service.password.error != null ? 20.h : 0.h;
                  return Container(
                    height: height,
                    margin: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      service.password.error ?? "",
                      style: GoogleFonts.inter(
                        color: AmptiveColors.whiteColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 12.sp,
                      ),
                    ),
                  );
                }),
                Expanded(
                  child: SizedBox(
                    height: 1.h,
                  ),
                ),
                BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                    builder: (context, state) {
                  return AmptiveElevatedButtonWidget(
                    margin: EdgeInsets.only(bottom: 29.h),
                    height: 50.w,
                    buttonTitle: AmptiveOtherStrings.next,
                    onPressed: state is ValidPasswordAuthState
                        ? () {
                            context.pushNamed(AmptiveRoutes.dobAuth);
                          }
                        : null,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 2.w, color: AmptiveColors.brandBlueColor),
      borderRadius: BorderRadius.circular(14.r),
    );
  }
}
