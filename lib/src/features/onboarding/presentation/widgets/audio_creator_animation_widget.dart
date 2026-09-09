import 'dart:async';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/lottie_animation_strings.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AmptiveAudioCreatorWidget extends StatefulWidget {
  const AmptiveAudioCreatorWidget(
      {super.key, required this.assetName, required this.delay});

  final String assetName;
  final int delay;

  @override
  State<AmptiveAudioCreatorWidget> createState() =>
      _AmptiveAudioCreatorWidgetState();
}

class _AmptiveAudioCreatorWidgetState extends State<AmptiveAudioCreatorWidget> {
  bool _isBorderColored = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: widget.delay), (_) {
      if (mounted) setState(() => _isBorderColored = !_isBorderColored);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: SizedBox(
            width: 74.99,
            height: 105.99,
            child: Visibility(
              visible: _isBorderColored,
              child: Lottie.asset(
                AmptiveLottieStrings.animate,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15, left: 15),
          width: 74.99,
          height: 74.99,
          child: CircleAvatar(
            radius: 36.5,
            backgroundColor:
                _isBorderColored ? ATColors.hex307FE2 : ATColors.transparent,
            child: CircleAvatar(
              radius: 34.814,
              backgroundColor: ATColors.hex0D0D0D,
              child: CircleAvatar(
                radius: 33.0,
                backgroundImage: AssetImage(widget.assetName),
              ),
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: 55,
          child: Visibility(
            visible: !_isBorderColored,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: ATColors.white,
              child: Icon(
                Icons.mic_off,
                color: ATColors.hex0D0D0D,
                size: 19,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key, required this.imgPath});

  final String imgPath;

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with TickerProviderStateMixin {
  late final AnimationController _cntrl1, _cntrl2;
  late final Animation<double> _spreadAnim1, _spreadAnim2;

  @override
  void initState() {
    super.initState();
    _cntrl1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _cntrl2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _spreadAnim1 = Tween<double>(begin: 0.0, end: 15.0)
        .animate(CurvedAnimation(parent: _cntrl1, curve: Curves.bounceInOut));

    _spreadAnim2 = Tween<double>(begin: 0.0, end: 8.0)
        .animate(CurvedAnimation(parent: _cntrl2, curve: Curves.decelerate));

    _cntrl1.addListener(() {
      if (_spreadAnim1.value >= 13.0 && !_cntrl2.isAnimating) {
        _cntrl2.forward();
      }
      if (_cntrl1.status == AnimationStatus.completed) {
        _cntrl2.reset();
        _cntrl1
          ..reset()
          ..forward();
      }
    });

    _cntrl1.forward();
  }

  @override
  void dispose() {
    _cntrl1.dispose();
    _cntrl2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          AnimatedBuilder(
              animation: _spreadAnim1,
              builder: (_, __) {
                return Container(
                  height: 70,
                  width: 70,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: _spreadAnim1.value,
                        blurRadius: 1,
                        color: ATColors.hex307FE2.withValues(alpha: 0.3),
                      )
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(),
                );
              }),
          AnimatedBuilder(
              animation: _spreadAnim2,
              builder: (_, __) {
                return Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: _spreadAnim2.value,
                        blurRadius: 1,
                        color: ATColors.hex307FE2.withValues(alpha: 0.5),
                      )
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(),
                );
              }),
          Container(
            padding: const EdgeInsets.all(2),
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: ATColors.black,
                border: Border.all(color: ATColors.hex307FE2, width: 3)),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(35),
              child: ATImgLoader(
                  height: 70,
                  width: 70,
                  imgPath: widget.imgPath,
                  boxFit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 5,
            child: ATCircleAvatar(
              diameter: 20,
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    Icons.mic_off,
                    color: ATColors.hex0D0D0D,
                    size: 15,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class RippleAnimationPage extends StatefulWidget {
  const RippleAnimationPage({super.key});

  @override
  _RippleAnimationPageState createState() => _RippleAnimationPageState();
}

class _RippleAnimationPageState extends State<RippleAnimationPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Create animation controller with 2 second duration
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Height animation from 70 to 100 (first half of animation)
    _heightAnimation = Tween<double>(
      begin: 70.0,
      end: 100.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Opacity animation from 1 to 0 (second half of animation)
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start the animation
    _startAnimation();
  }

  void _startAnimation() {
    _controller.forward().then((_) {
      // Reset and repeat the animation
      _controller.reset();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _startAnimation();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            width: _heightAnimation.value,
            height: _heightAnimation.value,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Alternative implementation with multiple ripples for a more realistic effect
class MultipleRippleAnimation extends StatefulWidget {
  const MultipleRippleAnimation({super.key});

  @override
  _MultipleRippleAnimationState createState() =>
      _MultipleRippleAnimationState();
}

class _MultipleRippleAnimationState extends State<MultipleRippleAnimation>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = <AnimationController>[];
  final List<Animation<double>> _scaleAnimations = <Animation<double>>[];
  final List<Animation<double>> _opacityAnimations = <Animation<double>>[];

  @override
  void initState() {
    super.initState();
    _createRipples();
    _startRipples();
  }

  void _createRipples() {
    for (int i = 0; i < 3; i++) {
      final AnimationController controller = AnimationController(
        duration: Duration(milliseconds: 2000 + (i * 200)),
        vsync: this,
      );

      final Animation<double> scaleAnimation = Tween<double>(
        begin: 0.7,
        end: 1.4,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));

      final Animation<double> opacityAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ));

      _controllers.add(controller);
      _scaleAnimations.add(scaleAnimation);
      _opacityAnimations.add(opacityAnimation);
    }
  }

  void _startRipples() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (mounted) {
          _controllers[i].repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final AnimationController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Multiple Ripple Animation'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(_controllers.length, (int index) {
            return AnimatedBuilder(
              animation: _controllers[index],
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _scaleAnimations[index].value,
                  child: Opacity(
                    opacity: _opacityAnimations[index].value,
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (final AnimationController controller in _controllers) {
            controller.reset();
          }
          _startRipples();
        },
        tooltip: 'Trigger Ripples',
        child: const Icon(Icons.water_drop),
      ),
    );
  }
}
