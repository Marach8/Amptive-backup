import 'dart:async';

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/shared/animated_slide.dart';
import 'package:amptive/src/shared/rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/custom_container_widget.dart';

const String _infoIconSvg = '''
<svg width="26" height="26" viewBox="0 0 26 26" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M13.0003 23.8346C18.9834 23.8346 23.8337 18.9844 23.8337 13.0013C23.8337 7.01822 18.9834 2.16797 13.0003 2.16797C7.01724 2.16797 2.16699 7.01822 2.16699 13.0013C2.16699 18.9844 7.01724 23.8346 13.0003 23.8346Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M13 17.3333V13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M13 8.66797H13.01" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

class AutoplayCountdownWidget extends StatelessWidget {
  const AutoplayCountdownWidget(
      {super.key,
      required this.isVisibleNotifier,
      required this.timeRemainingStreamCntrl,
      required this.onEnd});

  final ValueNotifier<bool> isVisibleNotifier;
  final StreamController<int> timeRemainingStreamCntrl;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isVisibleNotifier,
        child: Align(
          alignment: Alignment.center,
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              color: ATColors.white.withValues(alpha: 0.1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SvgPicture.string(
                    _infoIconSvg,
                    height: 22,
                    width: 22,
                  ),
                  const SizedBox(width: 10),
                  StreamBuilder<int>(
                      stream: timeRemainingStreamCntrl.stream,
                      builder: (_, AsyncSnapshot<int> snapshot) {
                        final int value = snapshot.data ?? 30;
                        return ATRichText(
                          maxLines: 2,
                          items: <String, TextStyle>{
                            '${ATStrings.RECORDING_WILL_AUTOPLAY} in ':
                                context.textTheme.bodySmall!,
                            value.toString(): context.textTheme.bodyMedium!,
                            value == 1 ? ' second' : ' seconds':
                                context.textTheme.bodySmall!,
                          },
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
        builder: (_, bool shouldShowInfo, Widget? child) {
          return AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              offset: shouldShowInfo ? Offset.zero : const Offset(0, 0.5),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: shouldShowInfo ? 1.0 : 0.0,
                onEnd: onEnd,
                child: child!,
              ));
        });
  }
}

class IsGoingLiveInfo extends StatelessWidget {
  const IsGoingLiveInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GoLiveOnboardBloc, (OnboardStage, bool), OnboardStage>(
        selector: ((OnboardStage, bool) state) => state.$1,
        builder: (_, OnboardStage state) {
          final bool showInfo = state == OnboardStage.isGoingLive;

          return ATAnimatedSlide(
            shouldSlide: showInfo,
            duration: 300,
            endOffset: const Offset(0, 0),
            startOffset: const Offset(0, 1.5),
            child: Align(
              alignment: Alignment.center,
              child: ATContainer(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                color: ATColors.white.withValues(alpha: 0.1),
                radius: 14,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.string(
                      _infoIconSvg,
                      height: 22,
                      width: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      ATStrings.MIC_ENHANCE_SOUND,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

