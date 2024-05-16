import 'dart:async';

import 'package:amptive/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/preference_provider.dart';
import '../utils/utils.dart';

const int MAX_NUMBER_COMMUNITIES = 5;


class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  bool isPreferenceSelected = false;

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<PreferenceModel>(context, listen: true);
    var len = model.items.length;
    var isOpaque = model.getSelected().length == MAX_NUMBER_COMMUNITIES;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        appBar: isPreferenceSelected ? null : BuildAppBar(),
        body: isPreferenceSelected
            ? const ProcessingPreference()
            : Padding(
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
                      child: Stack(
                        children: [
                          GridView.builder(
                            // shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 4.w,
                                    mainAxisSpacing: 4.h,
                                    crossAxisCount: 2,
                                    childAspectRatio: 169.w / 122.h),
                            itemBuilder: (_, index) => CommunityCardPreference(
                              width: 169.w,
                              height: 122.h,
                              index: index,
                              isOpaque: isOpaque,
                            ),
                            itemCount: len,
                          ),
                          Visibility(
                            visible: isOpaque,
                            child: Positioned(
                              left: 0.0,
                              right: 0.0,
                              bottom: 0.0,
                              child: Container(
                                width: 340.w,
                                height: 50.h,
                                padding: EdgeInsets.symmetric(horizontal: 25.w),
                                margin: EdgeInsets.only(bottom: 16.h),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isPreferenceSelected = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AmpColors.brandBlue,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 11.5.h),
                                  ),
                                  child: Text(
                                    'Next',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      height: 0.08,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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
    required this.index,
    required this.height,
    required this.width,
    required this.isOpaque,
  });

  final int index;
  double height;
  double width;
  final bool isOpaque;

  @override
  Widget build(BuildContext context) {
    var isSelected = true;
    return Consumer<PreferenceModel>(builder: (context, pref, child) {
      return Opacity(
        opacity: !pref.items[index].isSelected && isOpaque ? 0.6 : 1.0,
        child: GestureDetector(
          onTap: () {
            if( !pref.items[index].isSelected && isOpaque ){
              return;
            }

            pref.toggleSelectedByIndex(index);

          },
          child: Stack(
            children: [
              CommunityCardCommon(
                height: height,
                width: width,
                index: index,
                preference: pref.items[index],
                showCheckBox: pref.items[index].isSelected,
              ),
              Visibility(
                visible: pref.items[index].isSelected,
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
          ),
        ),
      );
    });
  }
}

class CommunityCardCommon extends StatelessWidget {
  CommunityCardCommon({
    super.key,
    required this.height,
    required this.width,
    required this.index,
    this.showCheckBox = false,
    required this.preference,
  });

  final double height;
  final double width;
  final int index;
  final Preferences preference;
  bool showCheckBox = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: preference.primary,
        borderRadius: BorderRadius.circular(5.h),
        gradient: LinearGradient(
            begin: const Alignment(0.00, -1.00),
            end: const Alignment(0, 1),
            colors: [preference.primary, preference.secondary]),
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
            top: 80.h,
            left: 16.w,
            child: Text(
              preference.name,
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

class ProcessingPreference extends StatefulWidget {
  const ProcessingPreference({
    super.key,
  });

  @override
  State<ProcessingPreference> createState() => _ProcessingPreferenceState();
}

class _ProcessingPreferenceState extends State<ProcessingPreference> {
  late String text;

  late List<Preferences> _list;
  int textListCounter = 1;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _list = Provider.of<PreferenceModel>(context, listen: false).getSelected();
    text = _list[0].name;

    Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          currentIndex = textListCounter % _list.length;
          text = _list[currentIndex].name;
          textListCounter++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var preference =
        Provider.of<PreferenceModel>(context, listen: false).getSelected();

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
                  index: 0,
                  preference: _list[currentIndex],
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
