import 'dart:math' as math;
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OnboardingOne extends StatefulWidget {
  const OnboardingOne({super.key});

  @override
  State<OnboardingOne> createState() => _OnboardingOneState();
}

class _OnboardingOneState extends State<OnboardingOne> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  static const List<OrbData> _orbs = <OrbData>[
    // Middle Circle (radiusFactor = 0.78)
    OrbData(
      radiusFactor: 0.78,
      angleDegrees: 0, // Right
      size: 66,
      url: ATImgStrings.middleRightAvatar,
      borderWidth: 2.5,
    ),
    OrbData(
      radiusFactor: 0.78,
      angleDegrees: 60, // Bottom-right
      size: 66,
      url: ATImgStrings.middleBottomRightAvatar,
      borderWidth: 2.5,
    ),
    OrbData(
      radiusFactor: 0.78,
      angleDegrees: 120, // Bottom-left
      size: 66,
      url: ATImgStrings.middleBottomLeftAvatar,
      borderWidth: 2.5,
    ),
    OrbData(
      radiusFactor: 0.78,
      angleDegrees: 180, // Left
      size: 48,
      url: ATImgStrings.middleLeftAvatar,
    ),
    OrbData(
      radiusFactor: 0.78,
      angleDegrees: 240, // Top-left
      size: 66,
      url: ATImgStrings.middleTopLeftAvatar,
      borderWidth: 2.5,
    ),
    OrbData(
      radiusFactor: 0.78,
      angleDegrees: 300, // Top-right
      size: 48,
      url: ATImgStrings.middleTopRightAvatar,
    ),

    // Outer Circle (radiusFactor = 1.34) - 4 bigger and 3 smaller (20px) alternating orbs clustered at the top (210 to 330 degrees)
    OrbData(
      radiusFactor: 1.34,
      angleDegrees: 210, // Upper-left (Bigger)
      size: 66,
      url: ATImgStrings.leftAvatar,
      borderWidth: 2.5,
    ),
    OrbData(
      radiusFactor: 1.34,
      angleDegrees: 230, // (Smaller)
      size: 20,
      url: ATImgStrings.smallLeftAvatar,
      borderWidth: 0.8,
    ),
    OrbData(
      radiusFactor: 1.34,
      angleDegrees: 250, // (Bigger)
      size: 48,
      url: ATImgStrings.midLeftAvatar,
      borderWidth: 2.0,
    ),
    OrbData(
      radiusFactor: 1.34,
      angleDegrees: 270, // Top Center (Smaller)
      size: 30,
      url: ATImgStrings.smallMidAvatar,
      borderWidth: 1.0,
    ),
    OrbData(
      radiusFactor: 1.34,
      angleDegrees: 290, // (Bigger)
      size: 66,
      url: ATImgStrings.midRightAvatar,
      borderWidth: 2.5,
    ),
    OrbData(
      radiusFactor: 1.34,
      angleDegrees: 310, // (Smaller)
      size: 25,
      url: ATImgStrings.smallRightAvatar,
      borderWidth: 1.0,
    ),
    OrbData(
      radiusFactor: 1.34,
      angleDegrees: 330, // Upper-right (Bigger)
      size: 48,
      url: ATImgStrings.rightAvatar,
      borderWidth: 2.0,
    ),
  ];

  static const List<String> _fallbacks = <String>[
    ATImgStrings.jpeg1,
    ATImgStrings.jpeg2,
    ATImgStrings.jpeg3,
    ATImgStrings.noAvatarImage,
  ];

  late final AnimationController _controller;
  late final AnimationController _loopController;
  late final Animation<double> _centerScale;
  late final Animation<double> _ringsScale;
  
  late final List<AudioPlayer> _audioPlayers;

  @override
  void initState() {
    super.initState();
    
    _audioPlayers = List.generate(_orbs.length + 1, (_) {
      return AudioPlayer();
    });
    
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
    _loopController = AnimationController(vsync: this, duration: const Duration(milliseconds: 8000));
    
    _centerScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
    );
    
    _ringsScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _loopController.repeat();
      }
    });

    final List<bool> hasPlayed = List.filled(_orbs.length + 1, false);

    _controller.addListener(() {
      // Center orb pops at 0.0
      if (!hasPlayed[0] && _controller.value > 0.0) {
        hasPlayed[0] = true;
        _audioPlayers[0].seek(Duration.zero);
        _audioPlayers[0].play();
      }

      // Outer orbs pop between 0.3 and 0.9
      for (int i = 0; i < _orbs.length; i++) {
        final double start = 0.3 + (i * (0.6 / _orbs.length));
        if (!hasPlayed[i + 1] && _controller.value >= start) {
          hasPlayed[i + 1] = true;
          _audioPlayers[i + 1].seek(Duration.zero);
          _audioPlayers[i + 1].play();
        }
      }
    });

    // Pre-load all audio assets in the background, but start the animation immediately
    Future.wait(_audioPlayers.map((p) => p.setAsset('assets/sounds/pop.wav'))).catchError((Object error) {
      return <void>[];
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _loopController.dispose();
    _controller.dispose();
    for (final player in _audioPlayers) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double size = math.min(width, height);
        final double baseRadius = size * 0.44;

        final double cx = width / 2;
        final double statusBarHeight = MediaQuery.of(context).padding.top;
        final double cy = statusBarHeight + 60 + (baseRadius * 1.34) + 23;

        final List<double> radii = <double>[
          baseRadius * 0.40, // Inner circle
          baseRadius * 0.78, // Middle circle
          baseRadius * 1.34, // Outer circle
        ];

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Concentric circle lines
            Positioned.fill(
              child: FadeTransition(
                opacity: _ringsScale,
                child: AnimatedBuilder(
                  animation: _loopController,
                  builder: (context, child) {
                    final double innerPulse = 1.0 + 0.015 * math.sin((_loopController.value * 2 * math.pi) + 0.0);
                    final double middlePulse = 1.0 + 0.015 * math.sin((_loopController.value * 2 * math.pi) + (math.pi * 0.5));
                    final double outerPulse = 1.0 + 0.015 * math.sin((_loopController.value * 2 * math.pi) + (math.pi));
                    
                    final List<double> animatedRadii = <double>[
                      radii[0] * innerPulse,
                      radii[1] * middlePulse,
                      radii[2] * outerPulse,
                    ];

                    return CustomPaint(
                      painter: ConcentricCirclesPainter(
                        radii: animatedRadii,
                        center: Offset(cx, cy),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Static Center Orb
            Positioned(
              left: cx - 46,
              top: cy - 46,
              width: 92,
              height: 92,
              child: AnimatedBuilder(
                animation: _loopController,
                builder: (context, child) {
                  final double centerPulse = 1.0 + 0.015 * math.sin(_loopController.value * 2 * math.pi);
                  return Transform.scale(
                    scale: centerPulse,
                    child: child,
                  );
                },
                child: ScaleTransition(
                  scale: _centerScale,
                  child: _buildAvatarOrb(
                    ATImgStrings.centerAvatar,
                    92,
                    0,
                    2.0, // borderWidth
                    4.0, // padding (creates the gap)
                  ),
                ),
              ),
            ),

            // Static Orbs that ripple with the rings
            ..._orbs.asMap().entries.map((MapEntry<int, OrbData> entry) {
              final int index = entry.key;
              final OrbData orb = entry.value;

              // Calculate staggered pop-in interval
              final double start = 0.3 + (index * (0.6 / _orbs.length));
              final double end = math.min(1.0, start + 0.2);
              
              final Animation<double> orbScale = CurvedAnimation(
                parent: _controller,
                curve: Interval(start, end, curve: Curves.easeOutCubic),
              );

              return AnimatedBuilder(
                animation: _loopController,
                builder: (context, child) {
                  double pulse = 1.0;
                  // Match the exact same sine wave phase as the concentric rings!
                  if (orb.radiusFactor > 1.0) { // outer ring (1.34)
                    pulse = 1.0 + 0.015 * math.sin((_loopController.value * 2 * math.pi) + (math.pi));
                  } else if (orb.radiusFactor > 0.5) { // middle ring (0.78)
                    pulse = 1.0 + 0.015 * math.sin((_loopController.value * 2 * math.pi) + (math.pi * 0.5));
                  }
                  // (Inner ring has no avatars)

                  final double radius = baseRadius * orb.radiusFactor * pulse;
                  final double rad = orb.angleDegrees * math.pi / 180;
                  final double x = cx + radius * math.cos(rad) - (orb.size / 2);
                  final double y = cy + radius * math.sin(rad) - (orb.size / 2);

                  return Positioned(
                    left: x,
                    top: y,
                    width: orb.size,
                    height: orb.size,
                    child: child!,
                  );
                },
                child: ScaleTransition(
                  scale: orbScale,
                  child: _buildAvatarOrb(orb.url, orb.size, entry.key, orb.borderWidth),
                ),
              );
            }),

            // Gradient Overlay
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.5, 1.0],
                      colors: [
                        Colors.transparent,
                        const Color(0xFF000000),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarOrb(String url, double size, int fallbackIndex, [double borderWidth = 2.0, double padding = 0.0]) {
    final String fallback = _fallbacks[fallbackIndex % _fallbacks.length];

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFFFFFF).withOpacity(0.32),
          width: borderWidth,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: ClipOval(
        child: _OrbImageLoader(
          url: url,
          fallbackAsset: fallback,
          size: size,
        ),
      ),
    );
  }
}

class OrbData {
  const OrbData({
    required this.radiusFactor,
    required this.angleDegrees,
    required this.size,
    required this.url,
    this.borderWidth = 2.0,
  });
  final double radiusFactor;
  final double angleDegrees;
  final double size;
  final String url;
  final double borderWidth;
}

class _OrbImageLoader extends StatelessWidget {
  const _OrbImageLoader({
    required this.url,
    required this.fallbackAsset,
    required this.size,
  });
  final String url;
  final String fallbackAsset;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (BuildContext context, String url) => ATShimmer(height: size, width: size),
        errorWidget: (BuildContext context, String url, Object error) => Image.asset(
          fallbackAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.asset(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          fallbackAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}

class ConcentricCirclesPainter extends CustomPainter {
  const ConcentricCirclesPainter({required this.radii, required this.center});
  final List<double> radii;
  final Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final double radius in radii) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConcentricCirclesPainter oldDelegate) {
    return oldDelegate.radii != radii || oldDelegate.center != center;
  }
}


class OnboardingTwo extends StatefulWidget {
  const OnboardingTwo({super.key});

  @override
  State<OnboardingTwo> createState() => _OnboardingTwoState();
}

class _OnboardingTwoState extends State<OnboardingTwo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _backCardRot;
  late final Animation<double> _midCardRot;
  late final Animation<double> _frontCardRot;
  late final Animation<double> _yOffset;
  late final Animation<double> _opacity;
  
  static bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    
    final CurvedAnimation springCurve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    final CurvedAnimation fadeCurve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    
    _backCardRot = Tween<double>(begin: 0.0, end: -0.25).animate(springCurve);
    _midCardRot = Tween<double>(begin: 0.0, end: 0.4).animate(springCurve);
    _frontCardRot = Tween<double>(begin: 0.0, end: -0.4).animate(springCurve);
    _yOffset = Tween<double>(begin: 100.0, end: 0.0).animate(springCurve);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(fadeCurve);
    
    if (!_hasAnimated) {
      // Slight delay so it animates right as the user finishes swiping to this page
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) {
          _controller.forward();
          _hasAnimated = true;
        }
      });
    } else {
      // If it has already animated once in this session, just snap to the final frame!
      _controller.value = 1.0;
    }
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
          opacity: _opacity.value,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(0, _yOffset.value),
                child: Transform.rotate(
                  angle: _backCardRot.value,
                  child: const ATImgLoader(
                    imgPath: ATImgStrings.onboard2c,
                    height: 385.52, width: 232.25
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                child: Transform.translate(
                  offset: Offset(0, _yOffset.value),
                  child: Transform.rotate(
                    angle: _midCardRot.value,
                    child: const ATImgLoader(
                      imgPath: ATImgStrings.onboard2b,
                      height: 385.52, width: 232.25
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                child: Transform.translate(
                  offset: Offset(0, _yOffset.value),
                  child: Transform.rotate(
                    angle: _frontCardRot.value,
                    child: const ATImgLoader(
                      imgPath: ATImgStrings.onboard2a,
                      height: 385.52, width: 232.25
                    ),
                  ),
                ),
              ),
              // Gradient Overlay (Extended downwards by 150px to hide the cards while sliding)
              Positioned(
                top: 0, left: -50, right: -50, bottom: -150,
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.35, 1.0], // Adjusted stop to keep the fade visually exactly where it was
                        colors: [
                          Colors.transparent,
                          Color(0xFF000000),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),
        );
      }
    );
  }
}

class OnboardingThree extends StatefulWidget {
  const OnboardingThree({super.key});

  @override
  State<OnboardingThree> createState() => _OnboardingThreeState();
}

class _OnboardingThreeState extends State<OnboardingThree> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideCurve;
  static bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _slideCurve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    
    if (!_hasAnimated) {
      // Delay slightly so it animates right as the user finishes swiping to this page
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) {
          _controller.forward();
          _hasAnimated = true;
        }
      });
    } else {
      // If already animated once, instantly snap to the final frame
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Screen width helps us perfectly calculate the exact offsets required to stack the cards
    final double screenW = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double t = _slideCurve.value;

        // Global sweep: the entire cluster starts 200px off-screen left and sweeps right
        final double globalX = -200.0 * (1.0 - t);
        
        // --- Left Card ---
        // Native position: left: -100, bottom: 15.
        final double leftCardX = globalX;
        final double leftCardAngle = 0.0 + (-0.0872665 * t); // Starts straight, ends tilted left (-5 deg)
        
        // --- Middle Card ---
        // Native position: horizontally centered (offset +20), bottom: 50.
        // Math to calculate X offset to perfectly stack on the Left Card at t=0
        final double midStartX = (-screenW / 2) - 4.0;
        final double midEndX = 20.0;
        final double midCardX = globalX + (midStartX + (midEndX - midStartX) * t);
        
        // Start at bottom: 15 (which is visually 35px DOWN from bottom: 50). End at native bottom: 50.
        final double midCardY = 35.0 * (1.0 - t); 
        final double midCardAngle = 0.0; // Always straight
        
        // --- Right Card ---
        // Native position: right: -160, bottom: 65.
        // Math to calculate X offset to perfectly stack on the Left Card at t=0
        final double rightStartX = -screenW - 28.0; 
        final double rightEndX = 0.0;
        final double rightCardX = globalX + (rightStartX + (rightEndX - rightStartX) * t);
        
        // Start at bottom: 15 (which is visually 50px DOWN from bottom: 65). End at native bottom: 65.
        final double rightCardY = 50.0 * (1.0 - t);
        final double rightCardAngle = 0.0 + (0.0872665 * t); // Starts straight, ends tilted right (+5 deg)
        
        // Opacity fade in
        final double opacity = Curves.easeOut.transform(_controller.value);

        return Opacity(
          opacity: opacity,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              // LEFT CARD
              Positioned(
                left: -100,
                bottom: 15,
                child: Transform.translate(
                  offset: Offset(leftCardX, 0),
                  child: Transform.rotate(
                    angle: leftCardAngle,
                    child: const ATImgLoader(
                      imgPath: ATImgStrings.onboard3a,
                      height: 385.52, width: null,
                    ),
                  ),
                ),
              ),
              // MIDDLE CARD
              Positioned(
                bottom: 50,
                child: Transform.translate(
                  offset: Offset(midCardX, midCardY),
                  child: Transform.rotate(
                    angle: midCardAngle,
                    child: const ATImgLoader(
                      imgPath: ATImgStrings.onboard3b,
                      height: 385.52, width: null,
                    ),
                  ),
                ),
              ),
              // RIGHT CARD
              Positioned(
                right: -160,
                bottom: 65,
                child: Transform.translate(
                  offset: Offset(rightCardX, rightCardY),
                  child: Transform.rotate(
                    angle: rightCardAngle,
                    child: const ATImgLoader(
                      imgPath: ATImgStrings.onboard3c,
                      height: 385.52, width: null,
                    ),
                  ),
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                        colors: [
                          Colors.transparent,
                          Color(0xFF000000),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),
        );
      }
    );
  }
}
