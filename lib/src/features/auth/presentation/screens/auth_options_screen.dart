import 'dart:io';

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/outlined_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

enum AuthType { signUp, signIn }

class ATAuthOptionsScreen extends StatelessWidget {
  const ATAuthOptionsScreen({super.key, required this.authType});

  final AuthType authType;

  @override
  Widget build(BuildContext context) {
    final bool isSignUp = authType == AuthType.signUp;
    final bool isIOS = Platform.isIOS;

    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leading: ATBackBtn(),
          bgColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                const _GlowingLogo(),
                const SizedBox(height: 20),
                Text(
                  isSignUp ? 'Create your account' : 'Welcome back',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  isSignUp
                      ? 'Join thousands of creators monetizing\nlive audio shows and events.'
                      : 'Sign back in and pick up right\nwhere you left off.',
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    height: 1.25,
                    color: ATColors.hexCDCDCD,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _CustomBtn(
                    isSignUp: isSignUp,
                    btnName: ATStrings.GOOGLE,
                    bgColor: Colors.white,
                    fgColor: Colors.black,
                    leading: const ATImgLoader(
                      imgPath: ATImgStrings.googleIcon,
                      height: 20,
                      width: 20,
                    ),
                    onPressed: () {}),
                const SizedBox(height: 15),
                if (isIOS) ...[
                  _CustomBtn(
                      isSignUp: isSignUp,
                      btnName: ATStrings.APPLE,
                      bgColor: Colors.white, // Apple HIG standard for Dark Mode
                      fgColor: Colors.black,
                      leading: const ATImgLoader(
                        imgPath: ATImgStrings.appleIcon,
                        height: 20,
                        width: 20,
                        color: Colors.black, // Recolor the white SVG to black
                      ),
                      onPressed: () {}),
                  const SizedBox(height: 15),
                ],
                const SizedBox(height: 25),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider(
                            color: Theme.of(context).dividerColor,
                            thickness: 0.5)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(ATStrings.or,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    Expanded(
                        child: Divider(
                            color: Theme.of(context).dividerColor,
                            thickness: 0.5)),
                  ],
                ),
                const SizedBox(height: 25),
                ATPlainElevatedBtn(
                    btnTitle: (isSignUp
                            ? ATStrings.signUpWith
                            : ATStrings.signInWith) +
                        ATStrings.email,
                    bgColor: const Color(0xFFFF0078),
                    fgColor: ATColors.white,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: ATColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    onPressed: () {
                      if (isSignUp) {
                        context.pushNamed(ATRoutes.emailScreen);
                      } else {
                        context.pushNamed(ATRoutes.temporaryLoginScreen);
                      }
                    }),
                const SizedBox(height: 15),
                ATPlainElevatedBtn(
                    btnTitle: (isSignUp
                            ? ATStrings.signUpWith
                            : ATStrings.signInWith) +
                        ATStrings.phoneNumber,
                    bgColor: ATColors.hex313131,
                    fgColor: ATColors.white,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: ATColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    onPressed: () {
                      if (isSignUp) {
                        context.pushNamed(ATRoutes.phoneAuthScreen);
                      } else {
                        context.pushNamed(ATRoutes.phoneLoginScreen);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomBtn extends StatelessWidget {
  const _CustomBtn({
    required this.isSignUp,
    required this.btnName,
    required this.leading,
    required this.onPressed,
    this.bgColor,
    this.fgColor,
  });

  final bool isSignUp;
  final String btnName;
  final Widget leading;
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? fgColor;

  @override
  Widget build(BuildContext context) {
    final String label =
        '${isSignUp ? ATStrings.signUpWith : ATStrings.signInWith}$btnName';

    return ATPlainElevatedBtn(
      onPressed: onPressed,
      bgColor: bgColor,
      fgColor: fgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          leading,
          const SizedBox(width: 12),
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
/// Glowing logo — the Amptive mark floats with a soft purple radial glow
/// that slowly breathes in and out. No surrounding shape, just light.
class _GlowingLogo extends StatefulWidget {
  const _GlowingLogo();

  @override
  State<_GlowingLogo> createState() => _GlowingLogoState();
}

class _GlowingLogoState extends State<_GlowingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (BuildContext context, Widget? child) {
        final double t = _glowAnim.value;
        return SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Outer soft glow halo
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromRGBO(123, 94, 255, 0.18 + t * 0.22),
                      blurRadius: 38 + t * 30,
                      spreadRadius: 8 + t * 18,
                    ),
                  ],
                ),
              ),
              // Inner core glow (tighter, brighter)
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromRGBO(155, 120, 255, 0.30 + t * 0.35),
                      blurRadius: 18 + t * 14,
                      spreadRadius: 2 + t * 6,
                    ),
                  ],
                ),
              ),
              // Amptive logo — white, no container
              const ATImgLoader(
                imgPath: ATImgStrings.AMPTIVE_LOGO,
                height: 64,
                width: 64,
              ),
            ],
          ),
        );
      },
    );
  }
}
