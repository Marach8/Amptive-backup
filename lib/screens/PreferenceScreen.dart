import 'dart:async';

import 'package:amptive/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/utils.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  final List<Pair<String, List<Color>>> _list = [
    Pair("Music", const [Color(0xFFEF8C62), Color(0xFFEF6262)]),
    Pair("Art", const [Color(0xFFD95335), Color(0xFFD93535)]),
    Pair("Society", const [Color(0xFFF9C407), Color(0xFFD9550C)]),
    Pair("Technology", const [Color(0xFFD9550C), Color(0xFFD93535)]),
    Pair("Sports", const [Color(0xFF009C51), Color(0xFF009C80)]),
    Pair("True Crime", const [Color(0xFF005A9C), Color(0xFF00249C)]),
    Pair("Business", const [Color(0xFFE14C1D), Color(0xFFE1721D)]),
    Pair("Spirituality", const [Color(0xFFEF8C62), Color(0xFFEF6262)]),
    Pair("Relationship", const [Color(0xFFD95335), Color(0xFFD93535)]),
    Pair("Science", const [Color(0xFF792166), Color(0xFF722179)]),
    Pair("Comedy", const [Color(0xFF7B0054), Color(0xFF7B003B)]),
    Pair("News", const [Color(0xFF307FE2), Color(0xFF306DE2)]),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        appBar: BuildAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.h, bottom: 11.h),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select 5 communities you find interest in.",
                  style: GoogleFonts.inter(
                    color: AmpColors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30.h),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your selected interests will be used to personalize you Amptive experience.",
                  style: GoogleFonts.inter(
                    color: const Color(0xFFCDCDCD),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  // shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 4.w,
                      mainAxisSpacing: 4.h,
                      crossAxisCount: 2,
                      childAspectRatio: 169.w / 122.h),
                  itemBuilder: (_, index) => CommunityCardPreference(
                    width: 169.w,
                    height: 122.h,
                    pair: _list[index],
                    index: index,
                  ),
                  itemCount: _list.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityCardPreference extends StatelessWidget {
  CommunityCardPreference({
    super.key,
    required Pair<String, List<Color>> pair,
    required this.index,
    required this.height,
    required this.width,
  }) : _pair = pair;

  final Pair<String, List<Color>> _pair;
  final int index;
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    var isSelected = true;
    return Stack(
      children: [
        CommunityCardCommon(
          height: height,
          width: width,
          pair: _pair,
          index: index,
          showCheckBox: isSelected,
        ),
        Visibility(
          visible: isSelected,
          child: Positioned(
            left: 2.w,
            top: 2.h,
            child: Container(
              width: 166.w,
              height: 119.h,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2.w,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: AmpColors.brandBlue,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommunityCardCommon extends StatelessWidget {
  CommunityCardCommon({
    super.key,
    required this.height,
    required this.width,
    required Pair<String, List<Color>> pair,
    required this.index,
    this.showCheckBox = false,
  }) : _pair = pair;

  final double height;
  final double width;
  final Pair<String, List<Color>> _pair;
  final int index;
  bool showCheckBox = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _pair.second[0],
        borderRadius: BorderRadius.circular(5.h),
        gradient: LinearGradient(
            begin: const Alignment(0.00, -1.00),
            end: const Alignment(0, 1),
            colors: [_pair.second[0], _pair.second[1]]),
      ),
      margin: EdgeInsets.only(
        top: 4.h,
        left: 4.w,
        bottom: 4.h,
        right: index % 2 == 0 ? 4.w : 4.w,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 86.h,
            left: 16.w,
            child: Text(
              _pair.first,
              style: GoogleFonts.inter(
                color: AmpColors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Visibility(
            visible: showCheckBox,
            child: Positioned(
              left: 127.w,
              top: 9.h,
              child: Container(
                width: 28.w,
                height: 28.h,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 28.h,
                        height: 28.h,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 20.h,
                          weight: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingPreference extends StatefulWidget {
  const LoadingPreference({
    super.key,
  });

  @override
  State<LoadingPreference> createState() => _LoadingPreferenceState();
}

class _LoadingPreferenceState extends State<LoadingPreference> {
  late String text;

  final List<Pair<String, List<Color>>> _list = [
    Pair("Music", const [Color(0xFFEF8C62), Color(0xFFEF6262)]),
    Pair("Art", const [Color(0xFFD95335), Color(0xFFD93535)]),
    Pair("Society", const [Color(0xFFF9C407), Color(0xFFD9550C)]),
    Pair("Technology", const [Color(0xFFD9550C), Color(0xFFD93535)]),
  ];

  int textListCounter = 1;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    text = _list[0].first;

    Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          currentIndex = textListCounter % _list.length;
          text = _list[currentIndex].first;
          textListCounter++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 184.h),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final inAnimation = TweenSequence([
                  TweenSequenceItem(
                      tween: ConstantTween(const Offset(0.0, 1.0)), weight: 2),
                  TweenSequenceItem(
                      tween: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: const Offset(0.0, 0.0),
                      ),
                      weight: 1),
                ]).animate(animation);

                final outAnimation = TweenSequence([
                  TweenSequenceItem(
                      tween: ConstantTween(const Offset(0.0, 1.0)), weight: 1),
                  TweenSequenceItem(
                      tween: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: const Offset(0.0, 0.0),
                      ),
                      weight: 1),
                ]).animate(animation);

                if (child.key == ValueKey(text)) {
                  return ClipRect(
                    child: SlideTransition(
                      position: inAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      ),
                    ),
                  );
                } else {
                  return ClipRect(
                    child: SlideTransition(
                      position: outAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      ),
                    ),
                  );
                }
              },
              child: SizedBox(
                key: ValueKey<String>(text),
                height: 114.23.w,
                width: 143.w,
                child: CommunityCardCommon(
                  height: 103.23.h,
                  width: 143.w,
                  pair: _list[currentIndex],
                  index: 0,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 17.h),
          child: Text(
            "Personalizing your experience...",
            style: GoogleFonts.inter(
              color: AmpColors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 0.09,
            ),
          ),
        )
      ],
    );
  }
}

class Templ extends StatelessWidget {
  const Templ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 169.w,
      height: 122.h,
      child: Stack(
        children: [
          Positioned(
            left: 2.w,
            top: 2.h,
            child: Container(
              width: 165.w,
              height: 118.h,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFF009C51), Color(0xC1009C7F)],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16.w,
                    top: 86.h,
                    child: Text(
                      'Sports',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 0.11,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 127.w,
                    top: 9.h,
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 28.h,
                              height: 28.h,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 169.w,
              height: 122.h,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2.w,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFF307FE2),
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
