import 'dart:async';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/other_widgets/post_authentication_widgets/add_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/font_sizes.dart';

class PostRegistrationScreen extends StatefulWidget {
  const PostRegistrationScreen({super.key});

  @override
  State<PostRegistrationScreen> createState() => _PostRegistrationScreenState();
}

class _PostRegistrationScreenState extends State<PostRegistrationScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 10),
      () => setState(() {
        _isLoading = false;
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ATColors.brandBlack,
      body: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.w),
        child: _isLoading ? const LoadingAccountWidget() : const AddPictureWidget(),
      ),
    ));
  }
}

class LoadingAccountWidget extends StatefulWidget {
  const LoadingAccountWidget({
    super.key,
  });

  @override
  State<LoadingAccountWidget> createState() => _LoadingAccountWidgetState();
}

class _LoadingAccountWidgetState extends State<LoadingAccountWidget> {
  late String text;

  var textList = [
    "We are creating your account",
    "Join or create live audio events",
    "Subscribe and support creators"
  ];

  int textListCounter = 1;

  @override
  void initState() {
    super.initState();
    text = textList[0];

    Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          text = textList[textListCounter % textList.length];
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
          margin: EdgeInsets.only(top: 270.h),
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
              child: Text(text,
                  key: ValueKey<String>(text),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: AmptiveFontSizes.size17,
                      )),
            ),
          ),
        ),
        const AmptiveLoadingIndicatorWidget(),
      ],
    );
  }
}
