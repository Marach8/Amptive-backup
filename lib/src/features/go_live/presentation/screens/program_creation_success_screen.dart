import 'dart:async';
import 'dart:typed_data';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/spotlight_beam.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../shared/elevated_button_widget.dart';

enum _AnimStage { start, end }

enum ButtonPressed { elevatedBtn, textBtn }

class ProgramCreationSuccessScreenParams {
  const ProgramCreationSuccessScreenParams({
    this.coverArtBytes,
    this.coverArtUrl,
    required this.title,
    required this.subtitle,
    required this.btnTitle,
    required this.txtBtnTitle,
    required this.topLogo,
    this.onClose,
  });

  // The cover can arrive either as freshly-picked bytes or as a URL (a
  // curated/existing cover). One of the two is provided.
  final Uint8List? coverArtBytes;
  final String? coverArtUrl;
  final String title, subtitle, btnTitle, txtBtnTitle;
  final Widget topLogo;
  // Where the top-left close (X) button takes the user. Falls back to the
  // dashboard when not provided.
  final VoidCallback? onClose;
}

class ProgramCreationSuccessScreen extends StatefulWidget {
  const ProgramCreationSuccessScreen({super.key, required this.params});
  final ProgramCreationSuccessScreenParams params;

  @override
  State<ProgramCreationSuccessScreen> createState() =>
      _ProgramCreationSuccessScreenState();
}

class _ProgramCreationSuccessScreenState
    extends State<ProgramCreationSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _spotlightFadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _scaleAnimation = Tween<double>(begin: 4.5, end: 1.0).animate(
        CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack)));

    _spotlightFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOut)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leadingWidth: 52,
          leading: ATXBackBtn(
            onTapOverride: widget.params.onClose ??
                () => context.goNamed(ATRoutes.dashboard),
          ),
          padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
        ),
        body: Container(
          height: context.screenHeight,
          width: context.screenWidth,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: <Widget>[
              if (widget.params.title == ATStrings.showIsSetup)
                const ProgramSuccessCheckmarkIcon()
              else
                widget.params.topLogo,
              const SizedBox(
                height: 15,
              ),
              Text(
                  textAlign: TextAlign.center,
                  widget.params.title,
                  maxLines: 2,
                  style: context.textTheme.displaySmall?.copyWith(
                      fontSize: ATSizes.size23, letterSpacing: -0.39)),
              const SizedBox(height: 10),
              Text(
                  textAlign: TextAlign.center,
                  widget.params.subtitle,
                  maxLines: 3,
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: ATColors.hexC2C2C2)),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: LayoutBuilder(builder: (_, BoxConstraints kst) {
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                        top: 140,
                        child: FadeTransition(
                          opacity: _spotlightFadeAnimation,
                          child: SpotlightBeam(
                            height: kst.maxHeight,
                            width: context.screenWidth * 2,
                            halfWidthOfSpot: 67,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                ATColors.hex0D0D0D,
                                ATColors.hex090909
                              ],
                            ),
                          ),
                        ),
                      ),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                            height: 140,
                            width: 134,
                            child: widget.params.coverArtBytes != null
                                ? Image.memory(
                                    widget.params.coverArtBytes!,
                                    fit: BoxFit.cover,
                                  )
                                : ATImgLoader(
                                    imgPath: widget.params.coverArtUrl ??
                                        ATImgStrings.createShowPlaceholder,
                                    boxFit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        child: Container(
                          width: context.screenWidth,
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ATPlainElevatedBtn(
                                onPressed: () =>
                                    context.pop(ButtonPressed.elevatedBtn),
                                btnTitle: widget.params.btnTitle,
                                bgColor: ATColors.white,
                                fgColor: ATColors.black,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: ATColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                  onTap: () =>
                                      context.pop(ButtonPressed.textBtn),
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Text(
                                      widget.params.txtBtnTitle,
                                      style: context.textTheme.bodyLarge
                                          ?.copyWith(fontSize: ATSizes.size17),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgramSuccessCalenderIcon extends StatelessWidget {
  const ProgramSuccessCalenderIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''<svg width="45" height="45" viewBox="0 0 45 45" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M43.75 23.75C43.75 34.7957 34.7957 43.75 23.75 43.75C12.7043 43.75 3.75 34.7957 3.75 23.75C3.75 12.7043 12.7043 3.75 23.75 3.75C34.7957 3.75 43.75 12.7043 43.75 23.75Z" fill="white"/>
<path d="M30.4167 16.6641H17.5833C16.5708 16.6641 15.75 17.4849 15.75 18.4974V31.3307C15.75 32.3433 16.5708 33.1641 17.5833 33.1641H30.4167C31.4292 33.1641 32.25 32.3433 32.25 31.3307V18.4974C32.25 17.4849 31.4292 16.6641 30.4167 16.6641Z" stroke="black" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M27.6663 14.8359V18.5026" stroke="black" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M20.3337 14.8359V18.5026" stroke="black" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M15.75 22.1641H32.25" stroke="black" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''',
      width: 45,
      height: 45,
    );
  }
}

class ProgramSuccessCheckmarkIcon extends StatelessWidget {
  const ProgramSuccessCheckmarkIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''<svg width="45" height="45" viewBox="0 0 45 45" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M22.5 41.25C32.8553 41.25 41.25 32.8553 41.25 22.5C41.25 12.1447 32.8553 3.75 22.5 3.75C12.1447 3.75 3.75 12.1447 3.75 22.5C3.75 32.8553 12.1447 41.25 22.5 41.25ZM18.7525 28.9084C19.1925 29.3791 19.8862 29.4706 20.4241 29.169C20.6801 29.1251 20.9264 29.0081 21.1299 28.8171L33.3175 17.3708C33.8695 16.8523 33.8967 15.9845 33.3783 15.4325C32.8598 14.8805 31.9921 14.8533 31.44 15.3717L19.9448 26.1677L13.623 19.4037C13.1059 18.8504 12.2382 18.8211 11.6849 19.3382C11.1317 19.8553 11.1023 20.723 11.6194 21.2763L18.7525 28.9084Z" fill="white"/>
</svg>''',
      width: 45,
      height: 45,
    );
  }
}

