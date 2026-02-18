import 'dart:async';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/features/auth/presentation/widgets/add_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/utils/font_sizes.dart';

class AddProfilePictureScreen extends StatefulWidget {
  const AddProfilePictureScreen({super.key});

  @override
  State<AddProfilePictureScreen> createState() => _AddProfilePictureScreenState();
}

class _AddProfilePictureScreenState extends State<AddProfilePictureScreen> {
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
      backgroundColor: ATColors.hex0D0D0D,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
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

  List<String> textList = <String>[
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
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 270.h),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final Animation<Offset> inAnimation = TweenSequence(<TweenSequenceItem<Offset>>[
                  TweenSequenceItem(
                      tween: ConstantTween(const Offset(0.0, 1.0)), weight: 2),
                  TweenSequenceItem(
                      tween: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: const Offset(0.0, 0.0),
                      ),
                      weight: 1),
                ]).animate(animation);

                final Animation<Offset> outAnimation = TweenSequence(<TweenSequenceItem<Offset>>[
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
                        fontSize: ATSizes.size17,
                      )),
            ),
          ),
        ),
        const ATLoadingIndicator(),
      ],
    );
  }
}
