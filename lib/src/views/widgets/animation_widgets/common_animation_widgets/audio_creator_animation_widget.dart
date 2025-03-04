import 'dart:async';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/lottie_animation_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AmptiveAudioCreatorWidget extends StatefulWidget {
  const AmptiveAudioCreatorWidget({
    super.key,
    required this.assetName,
    required this.delay
  });

  final String assetName;
  final int delay;

  @override
  State<AmptiveAudioCreatorWidget> createState() => _AmptiveAudioCreatorWidgetState();
}

class _AmptiveAudioCreatorWidgetState extends State<AmptiveAudioCreatorWidget>{
  bool _isBorderColored = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      Duration(seconds: widget.delay),
      (_) {
        if(mounted) setState(() => _isBorderColored = !_isBorderColored);
      }
    );
  }

  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: SizedBox(
            width: 74.99.w,
            height: 105.99.h,
            child: Visibility(
              visible: _isBorderColored,
              child: Lottie.asset(
                AmptiveLottieStrings.animate,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15.h, left: 15.w),
          width: 74.99.w,
          height: 74.99.h,
          child: CircleAvatar(
            radius: 36.5.r,
            backgroundColor:_isBorderColored ? ATColors.hex307FE2 : ATColors.transparentColor,
            child: CircleAvatar(
              radius: 34.814.r,
              backgroundColor: ATColors.brandBlack,
              child: CircleAvatar(
                radius: 33.0.r,
                backgroundImage: AssetImage(widget.assetName),
              ),
            ),
          ),
        ),
        Positioned(
          top: 60.h,
          left: 55.w,
          child: Visibility(
            visible: !_isBorderColored,
            child: CircleAvatar(
              radius: 12.r,
              backgroundColor: ATColors.whiteColor,
              child: Icon(
                Icons.mic_off,
                color: ATColors.brandBlack,
                size: 19.h,
              ),
            ),
          ),
        )
      ],
    );
  }
}