import 'dart:math';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LivestreamBloc, LivestreamState>(
      builder: (BuildContext context, LivestreamState state) {
        if (state.reactions.isEmpty) {
          return const SizedBox.shrink();
        }

        _controller.forward(from: 0);

        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final List<Widget> children = List<Widget>.generate(
              state.reactions.length.clamp(0, 5),
              (int index) {
                final ReactionEvent reaction = state.reactions[index];
                final double startX = Random().nextDouble() * 200 + 50;
                final double startY = 0.7;
                final double endX =
                    startX + (Random().nextDouble() - 0.5) * 100;
                final double endY = 0.1;

                final double progress = _controller.value;
                final double x = startX + (endX - startX) * progress;
                final double y = startY +
                    (endY - startY) * progress -
                    (progress * progress * 0.3);
                final double opacity = 1.0 - (progress * 0.8);

                return Positioned(
                  left: x,
                  top: y * MediaQuery.of(context).size.height,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Text(
                      reaction.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                );
              },
            );

            return Stack(children: children);
          },
        );
      },
    );
  }
}
