import 'dart:async';
import 'dart:typed_data';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/spotlight_beam.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/elevated_button_widget.dart';

enum _AnimStage { start, end }
enum ButtonPressed{elevatedBtn, textBtn}

class ProgramCreationSuccessScreenParams {
  const ProgramCreationSuccessScreenParams({
    required this.coverArtBytes,
    required this.title,
    required this.subtitle,
    required this.btnTitle,
    required this.txtBtnTitle,
    required this.topLogo,
  });

  final Uint8List coverArtBytes;
  final String title, subtitle, btnTitle, txtBtnTitle;
  final Widget topLogo;
}

class ProgramCreationSuccessScreen extends StatefulWidget {
  const ProgramCreationSuccessScreen({super.key, required this.params});
  final ProgramCreationSuccessScreenParams params;

  @override
  State<ProgramCreationSuccessScreen> createState() =>
      _ProgramCreationSuccessScreenState();
}

class _ProgramCreationSuccessScreenState
    extends State<ProgramCreationSuccessScreen> {
  final StreamController<_AnimStage> _streamCntrl =
      StreamController<_AnimStage>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _driveCoverArtAnim());
  }

  @override
  void dispose() {
    _streamCntrl.close();
    super.dispose();
  }

  void _driveCoverArtAnim() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _streamCntrl.add(_AnimStage.start);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    _streamCntrl.add(_AnimStage.end);
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leadingWidth: 30,
          leading: ATXBackBtn(),
          padding: EdgeInsets.fromLTRB(7, 0, 15, 0),
        ),
        body: Container(
          height: context.screenHeight,
          width: context.screenWidth,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: <Widget>[
              widget.params.topLogo,
              const SizedBox(
                height: 15,
              ),
              Text(
                  textAlign: TextAlign.center,
                  widget.params.title,
                  maxLines: 2,
                  style: context.textTheme.displaySmall
                      ?.copyWith(fontSize: ATSizes.size23)),
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
                child: LayoutBuilder(
                  builder: (_, BoxConstraints kst) {
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                        top: 140,
                        child: FutureBuilder<void>(
                            future: Future<void>.delayed(
                                const Duration(milliseconds: 800)),
                            builder: (_, AsyncSnapshot<void> snapshot) {
                              final bool isDone = snapshot.connectionState ==
                                  ConnectionState.done;
                              return SpotlightBeam(
                                  height: kst.maxHeight,
                                  width: context.screenWidth * 2,
                                  halfWidthOfSpot: 67,
                                  duration: 200,
                                  gradient: isDone
                                      ? LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: <Color>[
                                            ATColors.hex0D0D0D,
                                            ATColors.hex090909
                                          ],
                                        )
                                      : null);
                            }),
                      ),
                      StreamBuilder<_AnimStage>(
                        stream: _streamCntrl.stream,
                        builder: (_, AsyncSnapshot<_AnimStage> snapshot) {
                          if (snapshot.data == null) {
                            return const SizedBox.shrink();
                          }
                          final bool isDone = snapshot.data == _AnimStage.end;
                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 100),
                            left: !isDone ? -200 : null,
                            right: !isDone ? -200 : null,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: ATContainer(
                                duration: 200,
                                height: isDone ? 140 : kst.maxHeight,
                                width:
                                    isDone ? 134 : context.screenWidth * 1.5,
                                child: Image.memory(
                                    widget.params.coverArtBytes,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          );
                        }
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
                                onPressed: () => context.pop(ButtonPressed.elevatedBtn),
                                btnTitle: widget.params.btnTitle,
                                bgColor: ATColors.white,
                                fgColor: ATColors.black,
                              ),
                              const SizedBox(height: 15),
                              InkWell(
                                  onTap: () => context.pop(ButtonPressed.textBtn),
                                  borderRadius: BorderRadius.circular(5),
                                  child: Text(
                                    widget.params.txtBtnTitle,
                                    style: context.textTheme.bodyLarge
                                        ?.copyWith(fontSize: ATSizes.size17),
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
    return Container(
      height: 40, width: 40,
      decoration: BoxDecoration(
        color: ATColors.white,
        borderRadius: BorderRadius.circular(22.5),
      ),
      padding: const EdgeInsets.all(8),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
            ATColors.black, BlendMode.srcATop),
        child: const ATImgLoader(
          imgPath: ATImgStrings.calenderIcon,
          boxFit: BoxFit.cover,
        ),
      ),
    );
  }
}
