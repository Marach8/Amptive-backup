import 'dart:async';
import 'dart:math' as math;

import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';

class HashTagsSubtitleRow extends StatelessWidget {
  const HashTagsSubtitleRow(
      {super.key,
      required this.hashTagTitle,
      required this.hashTagSubTitle,
      required this.trailingOnpressed,
      this.showFlame = true});

  final String hashTagTitle, hashTagSubTitle;
  final VoidCallback trailingOnpressed;
  final bool showFlame;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          ATImgStrings.hashIcon,
          height: 25,
          width: 25,
          colorFilter: ColorFilter.mode(
            ATColors.white.withValues(alpha: 0.8),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '#${hashTagTitle.toLowerCase()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: ATSizes.size15),
                ),
                if (showFlame) ...<Widget>[
                  const SizedBox(width: 2),
                  const _AnimatedTrendingFlame(),
                ],
              ],
            ),
            Text(
              hashTagSubTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: ATSizes.size13, color: ATColors.hexC2C2C2),
            ),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: 44,
          height: 44,
          child: IconButton(
            onPressed: trailingOnpressed,
            padding: EdgeInsets.zero,
            splashRadius: 22,
            tooltip: 'View hashtag',
            icon: SvgPicture.asset(
              ATImgStrings.discoverChevronRightIcon,
              width: 20,
              height: 20,
            ),
          ),
        )
      ],
    );
  }
}

class _AnimatedTrendingFlame extends StatefulWidget {
  const _AnimatedTrendingFlame();

  @override
  State<_AnimatedTrendingFlame> createState() => _AnimatedTrendingFlameState();
}

class _AnimatedTrendingFlameState extends State<_AnimatedTrendingFlame>
    with SingleTickerProviderStateMixin {
  Timer? _flickerTimer;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _flickerTimer?.cancel();
      _flickerTimer = null;
      _controller.stop();
    } else if (_flickerTimer == null) {
      _playFlicker();
      _flickerTimer = Timer.periodic(
        const Duration(seconds: 8),
        (_) => _playFlicker(),
      );
    }
  }

  void _playFlicker() {
    if (!mounted || _controller.isAnimating) return;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _flickerTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          if (!_controller.isAnimating) return child!;

          final double phase = _controller.value * math.pi * 2;
          final double flicker =
              math.sin(phase * 2) * 0.045 + math.sin(phase * 5) * 0.018;
          final double stretch = 1 + flicker;
          final double width = 1 - (flicker * 0.35);
          final double intensity = 0.94 + math.sin(phase * 3).abs() * 0.06;

          return Transform.scale(
            scaleX: width,
            scaleY: stretch,
            alignment: Alignment.bottomCenter,
            child: Opacity(opacity: intensity, child: child),
          );
        },
        child: Icon(
          Icons.local_fire_department_rounded,
          size: 16,
          color: ATColors.hexFF0078,
        ),
      ),
    );
  }
}
