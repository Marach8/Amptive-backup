import 'package:amptive/src/global_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/livestream/livestream.dart';
import '../../go_live_export.dart';

class GiftOverlay extends StatefulWidget {
  const GiftOverlay({super.key});

  @override
  State<GiftOverlay> createState() => _GiftOverlayState();
}

class _GiftOverlayState extends State<GiftOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );

  int _previousGiftCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LivestreamBloc, LivestreamState>(
      builder: (BuildContext context, LivestreamState state) {
        final int currentCount = state.gifts.length;

        if (currentCount > _previousGiftCount && currentCount > 0) {
          _controller.forward(from: 0);
        }
        _previousGiftCount = currentCount;

        if (state.gifts.isEmpty || _controller.value >= 1.0) {
          return const SizedBox.shrink();
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final GiftEvent latestGift = state.gifts.last;
            final double progress = _controller.value;

            final double startY = 0.6;
            final double endY = 0.2;
            final double y = startY + (endY - startY) * progress;
            final double opacity = 1.0 - (progress * 0.3);

            return Positioned(
              left: 20,
              top: y * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: opacity.clamp(0.3, 1.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        latestGift.giftEmoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            latestGift.displayName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            latestGift.quantity > 1
                                ? 'x${latestGift.quantity} ${latestGift.giftName}'
                                : latestGift.giftName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
