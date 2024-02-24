import 'dart:async';

import 'package:amptive/routers/amptive_routes.dart';
import 'package:amptive/utils/utils.dart';
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
      () => context.pushReplacementNamed(AmptiveRoutes.onboarding),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmpColors.brandBlack,
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              "assets/Logo.svg",
              semanticsLabel: 'Amptive Logo',
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
