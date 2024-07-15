import 'package:amptive/providers/form_providers.dart';
import 'package:amptive/routers/amptive_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:provider/provider.dart';
import '../utils/common_widgets.dart';
import '../utils/utils.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  TextEditingController textController = TextEditingController();
  late FormProvider _formProvider;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _formProvider = Provider.of<FormProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        appBar: BuildAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What is your email?",
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
                  controller: textController,
                  onChanged: _formProvider.validateEmail,
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: _formProvider.email.error == null
                      ? AmpColors.brandBlue
                      : AmpColors.textRed,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    hintText: "Enter your email",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AmpColors.authHintColor,
                      fontWeight: FontWeight.normal,
                    ),
                    errorText: _formProvider.email.error,
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
                        color: _formProvider.email.error == null
                            ? AmpColors.brandBlue
                            : AmpColors.textRed,
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
                    fontSize: 18.sp,
                    color: AmpColors.white,
                  ),
                ),
                Consumer<FormProvider>(builder: (context, model, _) {
                  var height =
                      model.customEmailStatus.value != null ? 20.h : 0.h;
                  return Container(
                    height: height,
                    margin: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      model.customEmailStatus.value ?? "",
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
                      width: 500.w,
                      height: 50.w,
                      borderRadius: 100.r,
                      onTap: (start, stop, state) async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (state == ButtonState.idle) {
                          start();

                          if (_formKey.currentState!.validate() &&
                              model.isEmailValid) {
                            // call api
                            bool isUniqueEmail = await model.processEmail();

                            if (isUniqueEmail && context.mounted) {
                              context.pushNamed(AmptiveRoutes.otp, extra: "email");
                            }
                          }

                          stop();
                        }
                      },
                      validCondition: model.isEmailValid,
                      childText: "Verify Email",
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
