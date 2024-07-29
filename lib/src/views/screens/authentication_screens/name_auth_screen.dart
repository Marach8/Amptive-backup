import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/authentication/general/auth_bloc.dart';
import '../../../bloc/authentication/general/auth_states.dart';

class NameAuthScreen extends StatefulWidget {
  const NameAuthScreen({super.key});

  @override
  State<NameAuthScreen> createState() => _NameAuthScreenState();
}

class _NameAuthScreenState extends State<NameAuthScreen> {
  TextEditingController nameController = TextEditingController();
  late AuthFieldService service;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    service = GetIt.I<AuthFieldService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
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
                  AmptiveOtherStrings.whatIsYourName,
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
                  controller: nameController,
                  onChanged: (val){
                    service.validateName(val);

                    setState(() {

                    });
                  },
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  cursorColor: service.name.error == null
                      ? AmptiveColors.brandBlueColor
                      : AmptiveColors.textRedColor,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    hintText: AmptiveOtherStrings.enterYourName,
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
                        color: service.name.error == null
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
                Container(
                  height: 17.h,
                  margin: EdgeInsets.symmetric(
                    vertical: 11.h,
                  ),
                  child: Text(
                    AmptiveOtherStrings.noteAboutProfilePic,
                    style: GoogleFonts.inter(
                      color: AmptiveColors.whiteColor,
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
                      text: AmptiveOtherStrings.warningOnClickingCreate +
                          AmptiveOtherStrings.space,
                      children: [
                        TextSpan(
                          text: AmptiveOtherStrings.termsOfService +
                              AmptiveOtherStrings.space,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: AmptiveOtherStrings.and +
                              AmptiveOtherStrings.space,
                        ),
                        TextSpan(
                          text: AmptiveOtherStrings.privacyPolicy,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AmptiveColors.whiteColor,
                          fontWeight: FontWeight.normal,
                          height: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
            builder: (context, state) {
          return AmptiveElevatedButtonWidget(
            height: 50.w,
            margin: EdgeInsets.only(bottom: 29.h),
            buttonTitle: AmptiveOtherStrings.createAccount,
            onPressed: service.isNameValid
                ? () {
                    // Validate returns true if the form is valid, or false otherwise.
                    context.goNamed(AmptiveRoutes.addProfilePic);
                  }
                : null,
          );
        }),
      ),
    );
  }
}
