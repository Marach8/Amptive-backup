import 'dart:async';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/post_auth/presentation/widgets/pre_hompage_background.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';


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
    return ATAnnotatedRegion(
      child: Scaffold(
        backgroundColor: ATColors.hex0D0D0D,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 104,
              left: -178,
              child: Container(
                width: 390.13,
                height: 375.95,
                decoration: const ShapeDecoration(shape: OvalBorder()),
                child: const PreHomePageBackground(color: Color(0xAA00249C), angle: 0.52,)
              ),
            ),
            // Positioned(
            //   top: 200.42.h,
            //   right: -41.3.w,
            //   child: Container(
            //       width: 249.w,
            //       height: 291.h,
            //       decoration: const ShapeDecoration(shape: OvalBorder()),
            //       child: const PreHomePageBackground(color: Color(0xFFCACBCB), angle: 3.8,),
            //   ),
            // ),
            Column(
              children: <Widget>[
                const SizedBox(height: 73),
                Text(
                  'STAY ON THE LOOP', maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 45,
                    fontWeight: ATFontWeights.w800
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Text(
                    'Allow Amptive to send notifications of live audio shows & events ',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodySmall
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    width: context.screenWidth * 0.85,
                      clipBehavior: Clip.antiAlias,
                      decoration: const ShapeDecoration(
                        color: Color(0xB50C0C0C),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 5, color: Color(0x4C323033)),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        shadows: <BoxShadow>[
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                        Positioned(
                          top: 20,
                          child: ATContainer(
                            width: 80, height: 18,
                            color: ATColors.hex2F2F2F,
                            radius: 30,
                          )
                        ),
                      ]
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



// Positioned(
            //   bottom: 0,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     color: ATColors.hex0D0D0D,
            //     padding: EdgeInsets.only(left: 25.w),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: <Widget>[
            //         SizedBox(
            //           height: 22.h,
            //         ),
            //         AmptiveElevatedButtonWidget(
            //           height: 50.w,
            //           buttonTitle: ATStrings.ALLOW,
            //           onPressed: () {
            //             context.goNamed(ATRoutes.homeScreen);


            //           },
            //         ),
            //         SizedBox(
            //           height: 20.h,
            //         ),
            //         SizedBox(
            //           width: 321.w,
            //           height: 37.h,
            //           child: GestureDetector(
            //             onTap: () {
            //               context.goNamed(ATRoutes.homeScreen);
            //             },
            //             child: Container(
            //               padding: EdgeInsets.symmetric(vertical: 11.h),
            //               child: Text(
            //                 ATStrings.noThanks,
            //                 textAlign: TextAlign.center,
            //                 style: GoogleFonts.inter(
            //                   color: ATColors.white,
            //                   fontSize: 18.sp,
            //                   fontWeight: FontWeight.w600,
            //                   height: 0.18,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // )



//hild: const AmptiveNotificationAnimationWidget(),