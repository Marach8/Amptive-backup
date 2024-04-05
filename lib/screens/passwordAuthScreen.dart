import 'package:amptive/providers/form_providers.dart';
import 'package:amptive/routers/amptive_routes.dart';
import 'package:amptive/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class PasswordAuthScreen extends StatefulWidget {
  const PasswordAuthScreen({super.key});

  @override
  State<PasswordAuthScreen> createState() => _PasswordAuthScreenState();
}

class _PasswordAuthScreenState extends State<PasswordAuthScreen> {
  late FormProvider _formProvider;
  bool _passwordVisible = false;
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _formProvider = Provider.of<FormProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
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
                    color: AmpColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                TextFormField(
                  controller: passwordController,
                  onChanged: _formProvider.validatePassword,
                  maxLines: 1,
                  obscureText: !_passwordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: AmpColors.brandBlue,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 22.h, horizontal: 8.w),
                      hintText: "Enter your password",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: AmpColors.authHintColor,
                        fontWeight: FontWeight.normal,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                      focusedBorder: buildOutlineInputBorder(),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.w,
                          color: AmpColors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      suffixIcon: IconButton(
                        icon: Padding(
                          padding: EdgeInsets.only(right: 16.0.w),
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AmpColors.white,
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
                    color: AmpColors.white,
                  ),
                ),
                Consumer<FormProvider>(builder: (context, model, _) {
                  var height = model.password.error != null ? 20.h : 0.h;
                  return Container(
                    height: height,
                    margin: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      model.password.error ?? "",
                      style: GoogleFonts.inter(
                        color: AmpColors.white,
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
                Consumer<FormProvider>(builder: (context, model, _) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 29.h),
                    child: CustomLoaderButton(
                      width: 350.w,
                      height: 50.w,
                      borderRadius: 100.r,
                      onTap: (start, stop, state) async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (model.isPasswordValid) {
                          context.pushNamed(AmptiveRoutes.dobAuth);
                        }
                      },
                      validCondition: model.isPasswordValid,
                      childText: "Next",
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

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 2.w, color: AmpColors.brandBlue),
      borderRadius: BorderRadius.circular(30.r),
    );
  }
}
