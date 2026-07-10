import 'dart:async' show StreamController;
import 'package:amptive/src/global_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          const SizedBox(height: 10),
          BlocBuilder<GoLiveOnboardBloc, (OnboardStage, bool)>(
              builder: (_, (OnboardStage, bool) state) {
            final bool shouldRecord = state.$1 == OnboardStage.initial;
            final bool shouldActivateBtn = state.$2;
            final bool isGoingLive = state.$1 == OnboardStage.isGoingLive;

            return ATSmoothSwitcher(
              duration: 250,
              child: isGoingLive
                  ? const IsGoingLiveInfo()
                  : shouldRecord
                      // ── Initial state: Record button ──
                      ? ATPlainElevatedBtn(
                          key: const ValueKey<int>(3000),
                          onPressed: shouldActivateBtn
                              ? () {
                                  onShouldRecord.call();
                                  context
                                      .read<GoLiveOnboardBloc>()
                                      .setFullState((
                                    OnboardStage.isRecording,
                                    false,
                                  ));
                                }
                              : null,
                          btnTitle: ATStrings.RECORD,
                          fgColor: ATColors.white,
                          bgColor: ATColors.hexF92018,
                        )
                      // ── After playback: Sounds Good + Retry ──
                      : ValueListenableBuilder<bool>(
                          key: const ValueKey<int>(3001),
                          valueListenable: reRecordButtonNotifier,
                          builder: (_, bool showRetry, __) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Primary: "Sounds Good"
                                ATPlainElevatedBtn(
                                  onPressed: shouldActivateBtn
                                      ? () {
                                          context
                                              .read<GoLiveOnboardBloc>()
                                              .setStage(
                                                  OnboardStage.isGoingLive);
                                        }
                                      : null,
                                  btnTitle: ATStrings.soundsGood,
                                  fgColor: ATColors.black,
                                  bgColor: ATColors.white,
                                ),
                                // Secondary: "Retry" (appears after playback finishes)
                                if (showRetry) ...<Widget>[
                                  const SizedBox(height: 12),
                                  ATPlainElevatedBtn(
                                    onPressed: () {
                                      reRecordButtonNotifier.value = false;
                                      onPlayRefresh.call();
                                      context
                                          .read<GoLiveOnboardBloc>()
                                          .setFullState((
                                        OnboardStage.initial,
                                        true,
                                      ));
                                    },
                                    btnTitle: ATStrings.retry,
                                    fgColor: ATColors.white,
                                    bgColor: ATColors.white
                                        .withValues(alpha: 0.1),
                                    side: BorderSide(
                                      color: ATColors.white
                                          .withValues(alpha: 0.25),
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
            );
          }),
        ],
      ),
    );
  }
}
