import 'dart:async';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => context.pushReplacementNamed(ATRoutes.onboarding),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ATColors.hex0D0D0D,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 78.w,
              child: SvgPicture.asset(
                "assets/Logo1.svg",
                semanticsLabel: 'Amptive Logo',
              ),
            ),
          ),
          Positioned(
            bottom: 49.0.h,
            left: 150.0.w,
            right: 151.0.w,
            child: SvgPicture.asset(
              "assets/amptive_logotype.svg",
              semanticsLabel: 'Amptive Logo text',
            ),
          ),
        ],
      ),
    );
  }
}
