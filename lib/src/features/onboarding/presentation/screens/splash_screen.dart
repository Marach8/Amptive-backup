import 'dart:async';
import 'package:flutter/services.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routing/route_strings.dart';
import '../../../../config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import '../../../../config/utils/other_strings.dart';

class ATSplashScreen extends StatefulWidget {
  const ATSplashScreen({super.key});

  @override
  State<ATSplashScreen> createState() => _ATSplashScreenState();
}

class _ATSplashScreenState extends State<ATSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _wipeAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _ripple1ScaleAnim;
  late final Animation<double> _ripple1OpacityAnim;
  late final Animation<double> _ripple2ScaleAnim;
  late final Animation<double> _ripple2OpacityAnim;
  late final Animation<Color?> _bgColorAnim;
  late final Animation<Color?> _logoColorAnim;
  late final Animation<double> _massiveZoomAnim;
  late final Animation<double> _blackoutAnim;



  @override
  void initState() {
    super.initState();
    
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800), // Total sequence duration
    );

    // Stage 1: Fade in (0 to 1s)
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.26, curve: Curves.easeOut),
      ),
    );

    // Stage 2: Fast right-to-left wipe (1.5s to 1.875s)
    _wipeAnim = Tween<double>(begin: 1.0, end: 0.24).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.39, 0.49, curve: Curves.easeInOutCubic),
      ),
    );

    // Stage 3: Scale up the remaining logo mark (1.875s to 2.4s)
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.49, 0.63, curve: Curves.easeOutBack),
      ),
    );

    // Amplitude Wave (Ripple 1)
    _ripple1ScaleAnim = Tween<double>(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.49, 0.67, curve: Curves.easeOutCubic),
      ),
    );
    _ripple1OpacityAnim = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.49, 0.67, curve: Curves.easeOut),
      ),
    );

    // Amplitude Wave (Ripple 2)
    _ripple2ScaleAnim = Tween<double>(begin: 1.0, end: 2.6).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.53, 0.71, curve: Curves.easeOutCubic),
      ),
    );
    _ripple2OpacityAnim = Tween<double>(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.53, 0.71, curve: Curves.easeOut),
      ),
    );

    // Stage 4: Color Invert Background to White (2.4s to 2.85s)
    _bgColorAnim = ColorTween(begin: ATColors.black, end: ATColors.white).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.63, 0.75, curve: Curves.easeInOut),
      ),
    );

    // Stage 5: Color Invert Logo to Black (2.4s to 2.85s)
    _logoColorAnim = ColorTween(begin: ATColors.white, end: ATColors.black).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.63, 0.75, curve: Curves.easeInOut),
      ),
    );

    // Stage 6: Massive Zoom (2.85s to 3.42s) - Logo devours the camera!
    _massiveZoomAnim = Tween<double>(begin: 1.0, end: 150.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.75, 0.90, curve: Curves.easeInCubic),
      ),
    );

    // Stage 7: True Blackout (Hides any SVG gaps during massive zoom)
    _blackoutAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.90, 0.96, curve: Curves.easeOut),
      ),
    );

    _animController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final String? token = await FlutterSecureStorageServiceImpl().get(ATStrings.accessToken);
        if (mounted) {
          if (token != null && token.isNotEmpty) {
            context.goNamed(ATRoutes.dashboard);
          } else {
            context.goNamed(ATRoutes.onboardingScreen);
          }
        }
      }
    });

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _buildClippedSvg() {
    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: _wipeAnim.value,
        child: SvgPicture.asset(
          ATImgStrings.splashTextLogo,
          width: 220,
          colorFilter: ColorFilter.mode(
            _logoColorAnim.value ?? ATColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        final Color currentBgColor = _bgColorAnim.value ?? ATColors.black;
        
        // Dynamically switch status bar icons to dark when background is bright, 
        // but force them back to light when the blackout overlay starts fading in!
        final Brightness iconBrightness = (_blackoutAnim.value > 0.5) 
            ? Brightness.light 
            : (currentBgColor.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            statusBarIconBrightness: iconBrightness,
            systemNavigationBarIconBrightness: iconBrightness,
          ),
          child: Scaffold(
            backgroundColor: currentBgColor,
            body: Stack(
              children: [
                SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Align(
                        alignment: const Alignment(0.0, -0.1),
                        child: Opacity(
                          opacity: _fadeAnim.value,
                          child: Transform.scale(
                            scale: _massiveZoomAnim.value,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                // Amplitude Ripple 2 (Largest, delayed)
                                if (_ripple2OpacityAnim.value > 0)
                                  Opacity(
                                    opacity: _ripple2OpacityAnim.value,
                                    child: Transform.scale(
                                      scale: _ripple2ScaleAnim.value,
                                      child: _buildClippedSvg(),
                                    ),
                                  ),
                                  
                                // Amplitude Ripple 1
                                if (_ripple1OpacityAnim.value > 0)
                                  Opacity(
                                    opacity: _ripple1OpacityAnim.value,
                                    child: Transform.scale(
                                      scale: _ripple1ScaleAnim.value,
                                      child: _buildClippedSvg(),
                                    ),
                                  ),

                                // Main Logo
                                Transform.scale(
                                  scale: _scaleAnim.value,
                                  child: _buildClippedSvg(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // True blackout mask over everything right before navigation
                if (_blackoutAnim.value > 0)
                  Opacity(
                    opacity: _blackoutAnim.value,
                    child: Container(
                      color: ATColors.black,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
              ],
            ),
          ), // Closes Scaffold
        ); // Closes AnnotatedRegion
      },
    ); // Closes AnimatedBuilder
  }
}
