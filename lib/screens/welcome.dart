import 'package:amptive/routers/amptive_routes.dart';
import 'package:amptive/utils/sine_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
                margin: EdgeInsets.only(bottom: 87.h, top: 11.25.h),
                child: SvgPicture.asset(
                  "assets/Logo.svg",
                  semanticsLabel: 'Amptive Logo',
                ),
              ),
            ),
            Stack(
              children: [
                Positioned(
                  child: SizedBox(
                    height: 100.h,
                    child: const SineWaveImplementer(),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  left: 66.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AudioCreator(
                          assetName: "assets/welcomeAvatar2.jpeg",
                      delay: Duration(seconds: 1),),
                      SizedBox(
                        width: 22.w,
                      ),
                      const AudioCreator(
                          assetName: "assets/welcomeAvatar1.jpeg",
                        delay: Duration(seconds: 2),),
                      SizedBox(
                        width: 22.w,
                      ),
                      const AudioCreator(
                          assetName: "assets/welcomeAvatar3.jpeg",
                        delay: Duration(seconds: 3),),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 42.h, top: 109.07.h),
              alignment: Alignment.center,
              width: 257.w,
              height: 80.h,
              child: Text("Create or Listen to Live Audio Events",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bricolageGrotesque(
                    color: AmpColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25.sp,
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
                      onPressed: () {
                        context.goNamed(AmptiveRoutes.authScreen, extra: false);
                      },
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
                      onPressed: () {
                        context.goNamed(AmptiveRoutes.authScreen, extra: true);
                      },
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

class AudioCreator extends StatefulWidget {
  const AudioCreator({super.key, required this.assetName, required this.delay});

  final String assetName;
  final Duration delay;

  @override
  State<AudioCreator> createState() => _AudioCreatorState();
}

class _AudioCreatorState extends State<AudioCreator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isBorderColored = true;
  int repeater = 0;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));


    _animationController.addListener(() {
      setState(() {
        _isBorderColored = _animationController.value <= 0.5;
      });
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
         if(repeater >= 2){
           Future.delayed(widget.delay, () {
             repeater = 0;
             _animationController.reverse();

           });

         }else{
           repeater++;
           _animationController.reverse();

         }

      }else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController.forward(from: 0);
    // _animationController.repeat();


    super.initState();
  }



  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 74.99.w,
          height: 74.99.h,
          child: CircleAvatar(
            radius: 36.5.r,
            backgroundColor:_isBorderColored ? AmpColors.brandBlue : AmpColors.transparent,
            child: CircleAvatar(
              radius: 33.814.r,
              backgroundColor: AmpColors.brandBlack,
              child: CircleAvatar(
                radius: 31.0.r,
                backgroundImage: AssetImage(
                  widget.assetName,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
