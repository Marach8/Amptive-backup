import 'dart:async';

import 'package:amptive/screens/onboarding.dart';
import 'package:amptive/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
    ()=>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen())));
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
            bottom: 49.0,
            left: 150.0,
            right: 151.0,
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

