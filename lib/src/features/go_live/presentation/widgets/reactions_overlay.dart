import 'dart:math';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/global_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/livestream/livestream.dart';
import '../../go_live_export.dart';

class ReactionsOverlay extends StatefulWidget {
  const ReactionsOverlay({super.key});

  @override
  State<ReactionsOverlay> createState() => _ReactionsOverlayState();
}

class _ReactionsOverlayState extends State<ReactionsOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  int _previousReactionCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveStreamCubit1, LiveStreamState1>(
      builder: (BuildContext context, LiveStreamState1 state) {
        final int currentCount = 2;

        // Only trigger animation when a NEW reaction is added
        if (currentCount > _previousReactionCount && currentCount > 0) {
          _controller.forward(from: 0);
        }
        _previousReactionCount = currentCount;

        if (_controller.value >= 1.0) {
          return const SizedBox.shrink();
        }
        return Container();
        // return AnimatedBuilder(
        //   animation: _controller,
        //   builder: (_, __) {
        //     final List<Widget> children = List<Widget>.generate(
        //       state.reactions.length.clamp(0, 5),
        //       (int index) {
        //         final ReactionEvent reaction = state.reactions[index];
        //         final double startX = Random().nextDouble() * 200 + 50;
        //         final double startY = 0.7;
        //         final double endX =
        //             startX + (Random().nextDouble() - 0.5) * 100;
        //         final double endY = 0.1;

        //         final double progress = _controller.value;
        //         final double x = startX + (endX - startX) * progress;
        //         final double y = startY +
        //             (endY - startY) * progress -
        //             (progress * progress * 0.3);
        //         final double opacity = 1.0 - (progress * 0.5);

        //         return Positioned(
        //           left: x,
        //           top: y * MediaQuery.of(context).size.height,
        //           child: Opacity(
        //             opacity: opacity.clamp(0.3, 1.0),
        //             child: Container(
        //               padding: const EdgeInsets.all(8),
        //               decoration: BoxDecoration(
        //                 color: ATColors.black.withValues(alpha: 0.3),
        //                 borderRadius: BorderRadius.circular(20),
        //               ),
        //               child: Text(
        //                 reaction.emoji,
        //                 style: const TextStyle(fontSize: 40),
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //     );

        //     return Stack(children: children);
        //   },
        // );
      },
    );
  }
}
