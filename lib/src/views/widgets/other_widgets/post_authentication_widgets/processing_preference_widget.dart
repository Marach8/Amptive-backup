import 'dart:async';

import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../models/preferences.dart';
import '../../../../services/preference_service.dart';
import '../../../../utils/constants/strings/other_strings.dart';
import '../../../screens/post_authentication_screens/single_community_card.dart';

class ProcessingPreferenceWidget extends StatefulWidget {
  const ProcessingPreferenceWidget({
    super.key,
  });

  @override
  State<ProcessingPreferenceWidget> createState() =>
      _ProcessingPreferenceWidgetState();
}

class _ProcessingPreferenceWidgetState
    extends State<ProcessingPreferenceWidget> {
  late String text;

  late List<Preferences> _list;
  int textListCounter = 1;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _list = GetIt.I<PreferenceService>().getSelected();
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
                child: SingleCommunityCardWidget(
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
            AmptiveStrings.personalizingYourExperience,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: AmptiveFontSizes.size17,
                  height: 0.09,
                ),
          ),
        )
      ],
    );
  }
}
