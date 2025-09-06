import 'package:amptive/src/global_export.dart';


class InstructionsSwitcher extends StatelessWidget {
  const InstructionsSwitcher({
    super.key,
    required this.pageCntrl,
  });

  final  PageController pageCntrl;

  static final List<String> texts = <String>[
    ATStrings.TAP_D_RECORD_BTN, ATStrings.SPEAK_IN_2_MIC,
    ATStrings.SOUND_CHECK, ATStrings.GOING_LIVE_ON_AIR
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth, height: 110,
      child: PageView.builder(
        controller: pageCntrl,
        physics: const NeverScrollableScrollPhysics(),
        padEnds: false,
        itemBuilder: (_, int index){
          final String text = texts.elementAt(index);
          return Center(
            child: SizedBox(
              width: index == 2 ? 200 : 300, height: 100,
              child: Text(
                text.toUpperCase(),
                key: ValueKey<String>(text),
                textAlign: TextAlign.center, 
                maxLines: 3,
                style: context.textTheme.displayMedium?.copyWith(
                  color: ATColors.hexC2C2C2,
                  fontSize: 38, height: 0.85,
                  fontWeight: ATFontWeights.w800
                )
              ),
            ),
          );
        },
      ),
    );
  }
}