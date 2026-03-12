import 'dart:async' show StreamController;
import 'package:amptive/src/global_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../go_live_export.dart';

class GoLiveOnboardingBottomSheet extends StatelessWidget {
  const GoLiveOnboardingBottomSheet({
    super.key,
    required this.countDownVisibilityNotifier,
    required this.reRecordButtonNotifier,
    required this.timeRemainingStreamController,
    required this.onShouldRecord,
    required this.onAutoPlayCountDownEnd,
    required this.onPlayRefresh,
  });

  final ValueNotifier<bool> countDownVisibilityNotifier;
  final ValueNotifier<bool> reRecordButtonNotifier;
  final StreamController<int> timeRemainingStreamController;
  final VoidCallback onShouldRecord, onAutoPlayCountDownEnd, onPlayRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AutoplayCountdownWidget(
            isVisibleNotifier: countDownVisibilityNotifier,
            timeRemainingStreamCntrl: timeRemainingStreamController,
            onEnd: onAutoPlayCountDownEnd,
          ),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<GoLiveOnboardBloc, (OnboardStage, bool)>(
              builder: (_, (OnboardStage, bool) state) {
            final bool shouldRecord = state.$1 == OnboardStage.initial;
            final bool shouldActivateBtn = state.$2;
            final bool isGoingLive = state.$1 == OnboardStage.isGoingLive;

            return ATSlidingSwitcher(
              duration: 800,
              child: isGoingLive
                  ? const IsGoingLiveInfo()
                  : Row(
                      children: <Widget>[
                        Flexible(
                          child: ATPlainElevatedBtn(
                              onPressed: shouldActivateBtn
                                  ? () {
                                      if (shouldRecord) {
                                        onShouldRecord.call();
                                        context
                                            .read<GoLiveOnboardBloc>()
                                            .setFullState((
                                          OnboardStage.isRecording,
                                          false
                                        ));
                                      } else {
                                        context
                                            .read<GoLiveOnboardBloc>()
                                            .setStage(OnboardStage.isGoingLive);
                                      }
                                    }
                                  : null,
                              btnTitle: shouldRecord
                                  ? ATStrings.RECORD
                                  : ATStrings.done,
                              fgColor: shouldRecord
                                  ? ATColors.white
                                  : ATColors.black,
                              bgColor: shouldRecord
                                  ? ATColors.hexF92018
                                  : ATColors.white),
                        ),
                        ValueListenableBuilder<bool>(
                            valueListenable: reRecordButtonNotifier,
                            builder: (_, bool showBtn, __) {
                              return ATScalingSwitcher(
                                  child: showBtn
                                      ? Row(
                                          children: <Widget>[
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            ATContainer(
                                              key: const ValueKey<int>(2000),
                                              onTap: () {
                                                reRecordButtonNotifier.value =
                                                    false;
                                                //_hasPlayedAlready = false;
                                                onPlayRefresh.call();
                                                context
                                                    .read<GoLiveOnboardBloc>()
                                                    .setFullState((
                                                  OnboardStage.initial,
                                                  true
                                                ));
                                              },
                                              color: ATColors.white
                                                  .withValues(alpha: 0.1),
                                              radius: 30,
                                              height: 54,
                                              width: 54,
                                              child: const Icon(
                                                Iconsax.refresh,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(
                                          key: ValueKey<int>(2001),
                                        ));
                            })
                      ],
                    ),
            );
          })
        ],
      ),
    );
  }
}
