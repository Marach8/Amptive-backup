import 'package:amptive/src/global_export.dart';
import 'package:flutter/material.dart';

class OneTwoThreeCountDown extends StatelessWidget {
  const OneTwoThreeCountDown({
    super.key,
    required this.onCountDownFinished
  });

  final VoidCallback onCountDownFinished;

  Stream<(double?, double?, double?)> _generate123BottomValues() async* {
    await Future<void>.delayed(const Duration(seconds: 2));
    yield (50, 0, -50);
    await Future<void>.delayed(const Duration(seconds: 2));
    yield (100, 50, 0);
    await Future<void>.delayed(const Duration(seconds: 2));
    onCountDownFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 45, width: 45,
        child: StreamBuilder<(double?, double?, double?)>(
          initialData: (0, -50, -100),
          stream: _generate123BottomValues(),
          builder: (_, AsyncSnapshot<(double?, double?, double?)> snap) {
            final (double?, double?, double?) values = snap.data!;
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _PText(
                  text: '3',
                  bottom: values.$1,
                ),
                _PText(
                  text: '2',
                  bottom: values.$2,
                ),
                _PText(
                  text: '1',
                  bottom: values.$3
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

class _PText extends StatelessWidget {
  const _PText({
    required this.text,
    required this.bottom,
  });

  final String text;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: bottom,
      duration: const Duration(milliseconds: 500),
      child: Text(
        text,
        style: context.textTheme.displaySmall?.copyWith(
          fontSize: 30,
          height: 1.5
        )
      ),
    );
  }
}



// class TextInstructionSwitcher extends StatelessWidget {
//   const TextInstructionSwitcher({super.key, required this.text});

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 500),
//       reverseDuration: const Duration(milliseconds: 500),
//       switchInCurve: Curves.easeIn, switchOutCurve: Curves.easeIn,
//       transitionBuilder: (Widget child, Animation<double> animation) {
//         // Current text slides out to left
//         final Animation<Offset> outAnimation = Tween<Offset>(
//           begin: Offset.zero,
//           end: const Offset(-1.0, 0.0),
//         ).animate(animation);
        
//         // New text slides in from right
//         final Animation<Offset> inAnimation = Tween<Offset>(
//           begin: const Offset(1.0, 0.0),
//           end: Offset.zero,
//         ).animate(animation);
        
//         // Determine which animation to use
//         return SlideTransition(
//           position: child.key == ValueKey<String>(text) ? inAnimation : outAnimation,
//           child: child,
//         );
//       },
//       child: Text(
//         text.toUpperCase(),
//         key: ValueKey<String>(text),
//         textAlign: TextAlign.center, maxLines: 3,
//         style: context.textTheme.displayMedium?.copyWith(
//           color: ATColors.hexC2C2C2,
//           fontSize: 38, height: 0.85,
//           fontWeight: ATFontWeights.w800
//         )
//       ),
//     );
//   }
// }