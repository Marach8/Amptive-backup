import 'package:amptive/src/global_export.dart';
import 'package:flutter/material.dart';

class OneTwoThreeCountDown extends StatelessWidget {
  const OneTwoThreeCountDown({
    super.key,
    required this.onCountDownFinished
  });

  final VoidCallback onCountDownFinished;

  Stream<(double?, double?, double?)> _generate123BottomValues() async* {
    await Future<void>.delayed(const Duration(seconds: 3));
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
