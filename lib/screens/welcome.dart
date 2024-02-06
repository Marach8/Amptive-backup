import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/utils.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = PageController(viewportFraction: 1.0, keepPage: true);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      backgroundColor: AmpColors.brandBlack,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 67.w,
                height: 67.h,
                padding: EdgeInsets.all(8.h),
                margin: EdgeInsets.only(bottom: 87.h, top: 11.25.h),
                child: SvgPicture.asset(
                  "assets/Logo.svg",
                  semanticsLabel: 'Amptive Logo',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AudioCreator( assetName: "assets/welcomeAvatar2.jpeg"),
                SizedBox(
                  width: 22.w,
                ),
                const AudioCreator( assetName: "assets/welcomeAvatar1.jpeg"),
                SizedBox(
                  width: 22.w,
                ),
                const AudioCreator( assetName: "assets/welcomeAvatar3.jpeg"),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 42.h, top: 109.07.h),
              width: 257.w,
              height: 80.h,
              child: Text("Create or Listen to Live Audio Events",
                  style: GoogleFonts.bricolageGrotesque(
                    color: AmpColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25.sp,
                    letterSpacing: 0.4.sp,
                  )),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.h,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: AmpColors.white,
                        backgroundColor: AmpColors.brandBlue,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.h)),
                        ),
                      ),
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.26.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  SizedBox(
                    height: 50.h,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: AmpColors.white,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: AmpColors.strokeGray, width: 1.h),
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.h)),
                        ),
                      ),
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.26.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Center(
                    child: Text(
                      "Attend as guest",
                      style: GoogleFonts.inter(
                          color: AmpColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.26.sp),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class AudioCreator extends StatelessWidget {
  const AudioCreator({super.key, required this.assetName});

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 62.99.w,
          height: 62.99.h,
          child: CircleAvatar(
            radius: 169.814.h,
            backgroundImage: AssetImage(
              assetName,
            ),
          ),
        ),
      ],
    );
  }
}
