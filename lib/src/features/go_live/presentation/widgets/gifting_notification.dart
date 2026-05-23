import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GiftTravelItem extends StatefulWidget {
  const GiftTravelItem({
    super.key,
    required this.gift,
    required this.animation,       // from AnimatedList (enter/exit)
    required this.travelDuration,  // proportional to list height
    required this.onTravelComplete,
    required this.containerHeight,
  });

  final Gift gift;
  final Animation<double> animation;
  final Duration travelDuration;
  final VoidCallback onTravelComplete;
  final double containerHeight;

  @override
  State<GiftTravelItem> createState() => _GiftTravelItemState();
}

class _GiftTravelItemState extends State<GiftTravelItem>
    with SingleTickerProviderStateMixin {

  late final AnimationController _travelController;
  late final Animation<double> _travelAnimation; // raw pixel offset
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _travelController = AnimationController(
      vsync: this,
      duration: widget.travelDuration,
    );

    // moves upward by the full container height in pixels
    _travelAnimation = Tween<double>(
      begin: 0,
      end: -widget.containerHeight, // ✅ actual pixels upward
    ).animate(CurvedAnimation(
      parent: _travelController,
      curve: Curves.linear,
    ));

    // fade in at start, stay, fade out at end
    _fadeAnimation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 10),
        TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: 75),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 15),
      ]
    ).animate(_travelController);

    _travelController.forward().then((_) {
      if (mounted) widget.onTravelComplete();
    });
  }

  @override
  void dispose() {
    _travelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation, // AnimatedList enter/exit
      child: AnimatedBuilder(
        animation: _travelAnimation,
        builder: (_, Widget? child) => Transform.translate(
          offset: Offset(0, _travelAnimation.value),
          child: child,
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 8),
              child: GiftNotificationCard(gift: widget.gift),
            ),
          ),
        ),
      ),
    );
  }
}


class GiftNotificationCard extends StatelessWidget {
  const GiftNotificationCard({
    super.key,
    required this.gift,
  });

  final Gift gift;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: <Color>[
            ATColors.green1.withValues(alpha: 1.0),
            ATColors.hex009C80.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ATCircularImage(
            diameter: 30,
            imagePath: gift.gifter?.profilePicture ?? '',
          ),

          const SizedBox(width: 5),

          Text(
            gift.senderUserName ?? '',
            //gift.gifter?.name ?? '',
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: ATSizes.size12,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            '${ATStrings.gifted} '
            '${ATStrings.nairaText}${gift.quantity}',
            style: context.textTheme.titleSmall,
          ),

          const SizedBox(width: 10),

          const ATImgLoader(
            imgPath: ATImgStrings.moneyIcon,
          ),
        ],
      ),
    );
  }
}



class GiftOverlayOKay extends StatefulWidget {
  const GiftOverlayOKay({super.key});

  @override
  State<GiftOverlayOKay> createState() => _GiftOverlayOKayState();
}

class _GiftOverlayOKayState extends State<GiftOverlayOKay>
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
    return BlocBuilder<LiveStreamCubit1, LiveStreamState1>(
      builder: (BuildContext context, LiveStreamState1 state) {
        final int currentCount = 2;

        if (currentCount > _previousGiftCount && currentCount > 0) {
          _controller.forward(from: 0);
        }
        _previousGiftCount = currentCount;

        if (_controller.value >= 1.0) {
          return const SizedBox.shrink();
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
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
                        'Hello',
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Hello',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Hello',
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
