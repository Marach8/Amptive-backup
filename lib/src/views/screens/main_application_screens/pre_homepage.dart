import 'dart:async';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/notification_animation_widget.dart';
import 'package:amptive/src/views/screens/main_application_screens/pre_hompage_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PreHomePage extends StatefulWidget {
  const PreHomePage({super.key});

  @override
  State<PreHomePage> createState() => _PreHomePageState();
}

class _PreHomePageState extends State<PreHomePage>
    with SingleTickerProviderStateMixin {
  bool _isFirstImage = true;
  late Timer _initialDelayTimer;
  late Timer _periodicTimer;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize the Animation with a linear curve
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    // Start the initial delay timer (5000ms)
    _initialDelayTimer = Timer(const Duration(milliseconds: 5000), () {
      setState(() {
        // Start the periodic timer after the initial delay
        _periodicTimer =
            Timer.periodic(const Duration(milliseconds: 5000), (Timer timer) {
          setState(() {
            _isFirstImage = !_isFirstImage;
            _controller.reset();
            _controller.forward();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _initialDelayTimer.cancel();
    _periodicTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        body: Stack(
          children: [
            Positioned(
              top: 104.h,
              left: -178.w,
              child: Container(
                  width: 390.13.w,
                  height: 375.95.h,
                  decoration: const ShapeDecoration(
                    shape: OvalBorder(),
                  ),
                  child: const PreHomePageBackground(color: Color(0xAA00249C), angle: 0.52,)
              ),
            ),
            Positioned(
              top: 200.42.h,
              right: -41.3.w,
              child: Container(
                  width: 249.w,
                  height: 291.h,
                  decoration: const ShapeDecoration(shape: OvalBorder()),
                  child: const PreHomePageBackground(color: Color(0xFFCACBCB), angle: 3.8,),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 35.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 73.h,
                  ),
                  SizedBox(
                    width: 261.w,
                    child: Text(
                      'STAY ON THE LOOP',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AmpColors.white,
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    width: 282.w,
                    child: Text(
                      'Allow Amptive to send notifications of live audio shows & events ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AmpColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.28,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Expanded(
                    child: Container(
                        width: 320.w,
                        height: 517.h,
                        padding:
                            const EdgeInsets.only(top: 27, left: 15, right: 15),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xB50C0C0C),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 5.w, color: const Color(0x4C323033)),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.r),
                              topRight: Radius.circular(40.r),
                            ),
                          ),
                          shadows: [
                            BoxShadow(
                              color: const Color(0x3F000000),
                              blurRadius: 4.r,
                              offset: Offset(0, 4.h),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 60.w,
                                height: 18.h,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF2F2F2F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.only(
                                  top: 70.h,
                                ),
                                child: const NotificationAnimation(),
                              ))
                            ])),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: AmpColors.brandBlack,
                padding: EdgeInsets.only(left: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 22.h,
                    ),
                    SizedBox(
                      width: 340.w,
                      height: 50.w,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AmpColors.brandBlue),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          child: Text(
                            "Allow",
                            style: GoogleFonts.inter(
                              color: AmpColors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              height: 0.08,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      width: 321.w,
                      height: 37.h,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          child: Text(
                            "No Thanks",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: AmpColors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              height: 0.18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 11.h,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
