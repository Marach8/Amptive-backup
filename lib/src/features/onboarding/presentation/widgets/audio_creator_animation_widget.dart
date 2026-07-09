import 'dart:async';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/lottie_animation_strings.dart';
import 'dart:math';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/features/onboarding/presentation/widgets/audio_envelope.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:pausable_timer/pausable_timer.dart';

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
  const TestWidget({
    super.key, 
    required this.imgPath, 
    this.isAnimated = false,
    this.audioAsset,
    this.envelope,
    this.delay = Duration.zero,
    this.onSpeechStart,
  });

  final String imgPath;
  final bool isAnimated;
  final String? audioAsset;
  final List<double>? envelope;
  final Duration delay;
  final VoidCallback? onSpeechStart;

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with TickerProviderStateMixin {
  late final AnimationController _speechController;
  double _currentVolume = 1.0;
  double _targetVolume = 1.0;
  bool _isTalking = false;

  late final AnimationController _waveController;
  late final Animation<double> _waveScaleAnim;
  late final Animation<double> _waveOpacityAnim;

  AudioPlayer? _audioPlayer;
  StreamSubscription<Duration>? _positionSubscription;
  bool _isRouteVisible = true;
  PausableTimer? _startTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool isVisible = TickerMode.of(context);
    if (_isRouteVisible != isVisible) {
      _isRouteVisible = isVisible;
      if (!_isRouteVisible) {
        _startTimer?.pause();
        _audioPlayer?.pause();
      } else {
        _startTimer?.start();
        if (_isTalking) {
          _audioPlayer?.resume();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _speechController = AnimationController(vsync: this);

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800), // Very fast, snappy wave (0.8s)
      vsync: this,
    );

    _waveScaleAnim = Tween<double>(begin: 1.0, end: 1.6).animate(
        CurvedAnimation(parent: _waveController, curve: Curves.easeOutQuart));
    _waveOpacityAnim = Tween<double>(begin: 0.6, end: 0.0).animate(
        CurvedAnimation(parent: _waveController, curve: Curves.easeOutQuart));

    if (widget.isAnimated && widget.audioAsset != null && widget.envelope != null) {
      _startTimer = PausableTimer(widget.delay, () {
        if (!mounted) return;
        
        _audioPlayer = AudioPlayer();
        _audioPlayer!.setReleaseMode(ReleaseMode.stop); // Play exactly once and stop
        
        // Listen for audio completion to smoothly reset the UI and mute badge
        _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
          if (!mounted) return;
          if (state == PlayerState.completed || state == PlayerState.stopped) {
            setState(() {
              _isTalking = false;
              _currentVolume = _targetVolume;
              _targetVolume = 1.0;
            });
            _speechController.duration = const Duration(milliseconds: 300);
            _speechController.forward(from: 0.0);
          }
        });

        _audioPlayer!.play(AssetSource(widget.audioAsset!)).then((_) {
          if (!_isRouteVisible) {
            _audioPlayer!.pause();
          }
        });
        setState(() {
          _isTalking = true;
        });
        widget.onSpeechStart?.call();
        
        // Frame-perfect Lip Sync Engine!
        _positionSubscription = _audioPlayer!.onPositionChanged.listen((Duration position) {
          if (!mounted) return;
          
          // We sampled the MP3 every 50ms
          final int index = position.inMilliseconds ~/ 50;
          if (index >= 0 && index < widget.envelope!.length) {
            final double nextTarget = widget.envelope![index];
          
            _currentVolume = _targetVolume;
            _targetVolume = nextTarget;
            
            _speechController.duration = const Duration(milliseconds: 100);
            
            if (nextTarget > 1.35 && !_waveController.isAnimating) {
              _waveController.forward(from: 0.0);
            }
            
            _speechController.forward(from: 0.0);
          } else {
            // Safety catch: if audio position overshoots our envelope, force reset to silence!
            if (_targetVolume != 1.0) {
              setState(() {
                _currentVolume = _targetVolume;
                _targetVolume = 1.0;
              });
              _speechController.duration = const Duration(milliseconds: 100);
              _speechController.forward(from: 0.0);
            }
          }
      });
    });
    _startTimer?.start();
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _positionSubscription?.cancel();
    _audioPlayer?.dispose();
    _speechController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isTalking ? 1.15 : 0.85,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        height: 70,
        width: 70,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          // The Detaching Wave (Shoots out on loud bursts)
          if (widget.isAnimated)
            AnimatedBuilder(
              animation: _waveController,
              builder: (BuildContext context, Widget? child) {
                if (!_waveController.isAnimating) return const SizedBox.shrink();
                return Transform.scale(
                  scale: _waveScaleAnim.value,
                  child: Opacity(
                    opacity: _waveOpacityAnim.value,
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3), // FFFFFF 30%
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          // Erratic Speech Pulse (Thickness expands outward, inner hole stays fixed)
          if (widget.isAnimated)
            AnimatedBuilder(
              animation: _speechController,
              builder: (BuildContext context, Widget? child) {
                // Manually calculate the exact interpolated value using an easeOut curve
                final double curveValue = Curves.easeOut.transform(_speechController.value);
                final double val = (_currentVolume + (_targetVolume - _currentVolume) * curveValue);
                
                // The thickness explicitly expands outward from the edge of the avatar
                final double thickness = 2.0 + ((val - 1.0) * 20.0); // Expands from 2px up to 10px
                return Container(
                  height: 70, // Matches the avatar perfectly
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      // The solid ring (blurRadius 0 makes the shadow render as a hard, solid expanding border)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3), // FFFFFF 30%
                        blurRadius: 0,
                        spreadRadius: thickness,
                      ),
                      // Soft glow sitting just outside the solid ring
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1), // Subtle white glow
                        blurRadius: 15,
                        spreadRadius: thickness + 2,
                      ),
                    ],
                  ),
                );
              },
            ),
          // 3D Glass Bubble Avatar with Outer Stroke
          Container(
            height: 70,
            width: 70,
            padding: const EdgeInsets.all(3), // The tiny gap between avatar and stroke
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black, // This prevents the blue ripples underneath from bleeding through the gap
              border: Border.all(
                color: widget.isAnimated ? Colors.white : Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3), // Soft drop shadow
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // The Base Image
                ClipOval(
                  child: ATImgLoader(
                    imgPath: widget.imgPath,
                    boxFit: BoxFit.cover,
                  ),
                ),
                // Inner Shadow for Sphere Depth
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.5),
                      ],
                      stops: const <double>[0.6, 0.85, 1.0],
                    ),
                  ),
                ),
                // Glossy Highlight (Top Left)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.4, -0.5),
                      radius: 0.6,
                      colors: <Color>[
                        Colors.white.withValues(alpha: 0.6), // Bright highlight
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                      stops: const <double>[0.0, 0.4, 1.0],
                    ),
                  ),
                ),
                // Crisp Glass Rim & Bottom Reflection
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 0.5, // Thin crisp glass rim
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Colors.white.withValues(alpha: 0.5),
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.2), // Reflection on opposite side
                      ],
                      stops: const <double>[0.0, 0.2, 0.8, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Microphone Badge (Only show when muted or finished talking)
          if (!_isTalking)
            Positioned(
              bottom: 0,
              right: 5,
              child: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
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
              color: Colors.blue.withOpacity(0.3),
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
