import 'dart:async';
import 'dart:typed_data';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/spotlight_beam.dart';
import 'package:flutter/material.dart';
import '../../../../shared/elevated_button_widget.dart';

enum _AnimStage{start, end}

class GoLiveProgramCreationSuccessScreen extends StatefulWidget {

  const GoLiveProgramCreationSuccessScreen({
    super.key,
    required this.params
  });

  final ({
    Uint8List coverArtBytes,
    String title,
    String subtitle,
    String btnTitle,
    String txtBtnTitle,
    VoidCallback btnOnPressed,
    VoidCallback txtBtnOnPressed,
    Widget topLogo
  }) params;

  @override
  State<GoLiveProgramCreationSuccessScreen> createState() => _GoLiveProgramCreationSuccessScreenState();
}

class _GoLiveProgramCreationSuccessScreenState extends State<GoLiveProgramCreationSuccessScreen> {
  final StreamController<_AnimStage> _streamCntrl = StreamController<_AnimStage>();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _driveCoverArtAnim()
    );
  }

  @override
  void dispose(){
    _streamCntrl.close();
    super.dispose();
  }

  void _driveCoverArtAnim()async{
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
          leadingWidth: 30, leading: ATXBackBtn(),
          padding: EdgeInsets.fromLTRB(7, 0, 15, 0),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: <Widget>[
              widget.params.topLogo,
              const SizedBox(height: 15,),
              Text(
                textAlign: TextAlign.center,
                widget.params.title, maxLines: 2,
                style: context.textTheme.displaySmall?.copyWith(
                  fontSize: ATFontSizes.size23
                )
              ),
              const SizedBox(height: 10,),
              Text(
                textAlign: TextAlign.center,
                widget.params.subtitle, maxLines: 3,
                style: context.textTheme.bodySmall?.copyWith(
                  color: ATColors.hexC2C2C2
                )
              ),
              const SizedBox(height: 30,),
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
                          future: Future<void>.delayed(const Duration(milliseconds: 800)),
                          builder: (_, AsyncSnapshot<void> snapshot) {
                            final bool isDone = snapshot.connectionState == ConnectionState.done;
                              return SpotlightBeam(
                                height: kst.maxHeight, width: context.screenWidth * 2,
                                halfWidthOfSpot: 67, duration: 200,
                                gradient: isDone ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[ATColors.hex0D0D0D, ATColors.hex090909],
                                ) : null
                              );
                            }
                          ),
                        ),
                        StreamBuilder<_AnimStage>(
                          stream: _streamCntrl.stream,
                          builder: (_, AsyncSnapshot<_AnimStage> snapshot) {
                            if(snapshot.data == null){
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
                                  width: isDone ? 134 : context.screenWidth * 1.5,
                                  child: Image.memory(
                                    widget.params.coverArtBytes,
                                    fit: BoxFit.cover
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                        
                        Positioned(
                          bottom: 10,
                          child: SizedBox(
                            width: context.screenWidth - 30.0,
                            child: Column(
                              children: <Widget>[
                                ATPlainElevatedBtn(
                                  onPressed: widget.params.btnOnPressed,
                                  btnTitle: widget.params.btnTitle,
                                  bgColor: ATColors.white,
                                  fgColor: ATColors.black,
                                ),
                                const SizedBox(height: 15,),
                                InkWell(
                                  onTap: widget.params.txtBtnOnPressed,
                                  borderRadius: BorderRadius.circular(5),
                                  child: Text(
                                    widget.params.txtBtnTitle,
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      fontSize: ATFontSizes.size17
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
