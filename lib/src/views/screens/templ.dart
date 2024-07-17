import 'dart:async';
import 'dart:ui';

import 'package:amptive/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TempL extends StatefulWidget {
  const TempL({Key? key}) : super(key: key);

  @override
  State<TempL> createState() => _TempLState();
}

class _TempLState extends State<TempL> with SingleTickerProviderStateMixin {
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
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize the Animation with a linear curve
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    // Start the initial delay timer (5000ms)
    _initialDelayTimer = Timer(Duration(milliseconds: 5000), () {
      setState(() {
        // Start the periodic timer after the initial delay
        _periodicTimer = Timer.periodic(Duration(milliseconds: 5000), (Timer timer) {
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
              top: 57.h,
              left: -108.w,
              child: Container(
                width: 390.13.w,
                height: 375.95.h,
                decoration: const ShapeDecoration(
                  shape: OvalBorder(),
                ),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (child, animation){
                    return Opacity(
                      opacity: _animation.value,
                      child: _isFirstImage
                          ? Image.asset('assets/movAnimate.png', key: const ValueKey(1),  fit: BoxFit.fill,)
                          : Image.asset('assets/movAnimate2.png', key: const ValueKey(2),  fit: BoxFit.fill,),

                    );
                  },
                )
              ),
            ),
            Positioned(
              top: 124.42.h,
              right: -41.3.w,
              child: Container(
                width: 249.w,
                height: 291.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: OvalBorder()
                  ),


                  child:  AnimatedBuilder(
                  animation: _animation,
                  builder: (child, animation){
                    return Opacity(
                      opacity: _animation.value,
                      child: _isFirstImage
                          ? Image.asset('assets/whiteAnimate.png', key: const ValueKey(1), fit: BoxFit.fill,)
                          : Image.asset('assets/whiteAnimate2.png', key: const ValueKey(2), fit: BoxFit.fill,),

                    );
                  },
                )
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildBlurredImage(String assetPath) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SvgPicture.asset(assetPath),
    );
  }
}
