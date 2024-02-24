import 'package:amptive/providers/form_providers.dart';
import 'package:amptive/routers/amptive_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class NameAuthScreen extends StatefulWidget {
  const NameAuthScreen({super.key});

  @override
  State<NameAuthScreen> createState() => _NameAuthScreenState();
}

class _NameAuthScreenState extends State<NameAuthScreen> {
  TextEditingController nameController = TextEditingController();
  late FormProvider _formProvider;
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
                  "What is your name?",
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
                  controller: nameController,
                  onChanged: _formProvider.validateName,
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  cursorColor: _formProvider.name.error == null
                      ? AmpColors.brandBlue
                      : AmpColors.textRed,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AmpColors.authHintColor,
                      fontWeight: FontWeight.normal,
                    ),
                    errorText: _formProvider.name.error,
                    errorStyle: GoogleFonts.inter(
                      color: AmpColors.textRed,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: _formProvider.name.error == null
                            ? AmpColors.brandBlue
                            : AmpColors.textRed,
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: AmpColors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.sp,
                      color: AmpColors.white),
                ),
                Container(
                  height: 17.h,
                  margin: EdgeInsets.symmetric(vertical: 11.h),
                  child: Text(
                    "Note that this will appear on your profile.",
                    style: GoogleFonts.inter(
                      color: AmpColors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 1.h,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 22.h),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text:
                          "By clicking on ‘Create account’, you agree to the  ",
                      children: [
                        TextSpan(
                          text: "Terms of Service ",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: "and ",
                        ),
                        TextSpan(
                          text: "Privacy Policy.",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AmpColors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
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
                        if (model.isNameValid) {
                          context.goNamed(AmptiveRoutes.preference);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: model.isNameValid
                              ? AmpColors.brandBlue
                              : const Color(0xFF2F2F2F)),
                      child: Text(
                        "Create account",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: model.isNameValid
                                ? AmpColors.white
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
