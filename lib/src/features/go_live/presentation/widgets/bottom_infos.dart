import 'dart:async';

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/shared/animated_slide.dart';
import 'package:amptive/src/shared/rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/custom_container_widget.dart';

class AutoplayCountdownWidget extends StatelessWidget {
  const AutoplayCountdownWidget({
    super.key,
    required this.isVisibleNotifier,
    required this.timeRemainingStreamCntrl,
    required this.onEnd
  });

  final ValueNotifier<bool> isVisibleNotifier;
  final StreamController<int> timeRemainingStreamCntrl;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isVisibleNotifier,
      child: ATContainer(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        color: ATColors.white.withValues(alpha: 0.1),
        radius: 14,
        child: Row(
          children: <Widget>[
            const Icon(CupertinoIcons.info),
            const SizedBox(width: 10,),
            Flexible(
              child: StreamBuilder<int>(
                stream: timeRemainingStreamCntrl.stream,
                builder: (_, AsyncSnapshot<int> snapshot) {
                  final int value = snapshot.data ?? 30;
                  return ATRichText(
                    maxLines: 2,
                    items: <String, TextStyle>{
                      '${ATStrings.RECORDING_WILL_AUTOPLAY} in ': context.textTheme.bodySmall!,
                      value.toString() : context.textTheme.bodyMedium!,
                      value == 1 ? ' second' : ' seconds': context.textTheme.bodySmall!,
                    },
                  );
                }
              ),
            )
          ],
        ),
      ),
      builder: (_, bool shouldShowInfo, Widget? child) {
        return AnimatedScale(
          duration: const Duration(milliseconds: 500),
          scale: shouldShowInfo ? 1.0 : 0.0,
          //After this widget is slided into view, we kick of the countdown.
          onEnd: onEnd,
          child: child!
        );
      }
    );
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
          shouldSlide: showInfo, duration: 800,
          endOffset: const Offset(0, 0),
          startOffset: const Offset(0, 1.5),
          child: ATContainer(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            color: ATColors.white.withValues(alpha: 0.1),
            radius: 14,
            child: Row(
              children: <Widget>[
                const Icon(CupertinoIcons.info),
                const SizedBox(width: 10,),
                Flexible(
                  child: Text(
                    ATStrings.MIC_ENHANCE_SOUND,
                    style: context.textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}