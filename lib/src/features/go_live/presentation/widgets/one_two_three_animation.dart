import 'dart:math' as math;
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';

class OneTwoThreeCountDown extends StatefulWidget {
  const OneTwoThreeCountDown({super.key, required this.onCountDownFinished});

  final VoidCallback onCountDownFinished;

  @override
  State<OneTwoThreeCountDown> createState() => _OneTwoThreeCountDownState();
}

class _OneTwoThreeCountDownState extends State<OneTwoThreeCountDown>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _number = 3;
  bool _hasFinished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addStatusListener(_handleAnimationStatus)
      ..forward();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _hasFinished) return;
    if (_number > 1) {
      setState(() => _number -= 1);
      _controller.forward(from: 0);
      return;
    }
    _hasFinished = true;
    widget.onCountDownFinished();
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final double t = _controller.value;
            final double entrance = Curves.easeOutBack.transform(
              (t / 0.42).clamp(0.0, 1.0),
            );
            final double exit = Curves.easeInCubic.transform(
              ((t - 0.66) / 0.34).clamp(0.0, 1.0),
            );
            final double scale = 0.74 + (0.38 * entrance) - (0.18 * exit);
            final double opacity = (1 - exit).clamp(0.0, 1.0);
            final double pulse = math.sin(t * math.pi).clamp(0.0, 1.0);

            return Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Transform.scale(
                    scale: 0.7 + (0.7 * pulse),
                    child: Container(
                      height: 142,
                      width: 142,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            ATColors.white.withValues(
                              alpha: 0.18 * (1 - exit),
                            ),
                            ATColors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: scale,
                    child: Text(
                      '$_number',
                      textAlign: TextAlign.center,
                      style: context.textTheme.displayLarge?.copyWith(
                        color: ATColors.white,
                        fontSize: 92,
                        height: 0.92,
                        fontWeight: ATFontWeights.w900,
                        letterSpacing: -2.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
