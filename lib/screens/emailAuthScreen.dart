import 'package:amptive/routers/amptive_routes.dart';
import 'package:amptive/validators/Validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/utils.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _emailExistMsg = 'hett';



  @override
  Widget build(BuildContext context) {
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
                  validator: FormBuilderValidators.compose([
                    Validators.validateEmail,
                        (val) {
                    // todo
                      // if (1 == 1) {
                      //   setState(() {
                      //     _emailExistMsg = "Email already exist";
                      //   });
                      //   return "";
                      // }
                      return null;
                    },
                  ]),
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AmpColors.textRed,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: AmpColors.textRed,
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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_emailExistMsg, style: TextStyle(color: Colors.red),),
                ),

                Expanded(
                  child: SizedBox(
                    height: 1.h,
                  ),
                ),
                Container(
                  width: 350.w,
                  height: 50.w,
                  margin: EdgeInsets.only(bottom: 29.h),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                       context.goNamed(AmptiveRoutes.preference);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F2F2F)
                    ),
                    child: Text(
                      "Verify Email",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: const Color(0xFF666666)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
