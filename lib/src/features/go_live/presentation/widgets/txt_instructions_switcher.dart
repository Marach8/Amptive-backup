import 'package:amptive/src/global_export.dart';

class InstructionsSwitcher extends StatelessWidget {
  const InstructionsSwitcher({
    super.key,
    required this.stageIndex,
  });

  final int stageIndex;

  static final List<String> texts = <String>[
    ATStrings.TAP_D_RECORD_BTN,
    ATStrings.SPEAK_IN_2_MIC,
    ATStrings.SOUND_CHECK,
    ATStrings.GOING_LIVE_ON_AIR,
  ];

  @override
  Widget build(BuildContext context) {
    final int index = stageIndex.clamp(0, texts.length - 1);
    final String text = texts.elementAt(index);

    return SizedBox(
      width: context.screenWidth,
      height: 110,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          reverseDuration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            final Animation<double> curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            final Animation<double> scale = Tween<double>(
              begin: 0.92,
              end: 1,
            ).animate(curved);

            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: scale,
                child: child,
              ),
            );
          },
          child: SizedBox(
            key: ValueKey<String>(text),
            width: index == 2 ? 200 : 300,
            height: 100,
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 3,
              style: context.textTheme.displayMedium?.copyWith(
                color: ATColors.hexC2C2C2,
                fontSize: 38,
                height: 0.85,
                fontWeight: ATFontWeights.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
