import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/utils.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                maxLines: 1,
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
                  enabledBorder: OutlineInputBorder(
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
              Expanded(
                child: SizedBox(
                  height: 1.h,
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Verify Email",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
