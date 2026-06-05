import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/recent_searches_widgets/container_with_picture.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:amptive/main.dart';
import 'dart:developer' as marach show log;

import 'package:flutter_bloc/flutter_bloc.dart';

class MinimizedLiveProgramIndicator extends StatelessWidget {
  const MinimizedLiveProgramIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveStreamState1 state = context.watch<LiveStreamCubit1>().state;
    final String? programUrl = state.programCoverUrl;
    final String? title = state.programTitle;
    final String? hostId = state.organizersIds?.hostId;
    final String? hostName = state.allParticipants?[hostId]?.username;

    String peopleInLive = '';
    final int totalParticipants = state.allParticipantsIds?.length ?? 0;
    if(totalParticipants == 0){
      peopleInLive = 'No one is here yet...';
    }
    else if(totalParticipants == 1){
      peopleInLive = '${hostName ?? 'You'} and ${totalParticipants - 1} other';
    }
    else{
      peopleInLive = '${hostName ?? 'You'} and ${totalParticipants - 1} others';
    }

    final double width = context.screenWidth - 20;
    return Material(
      color: ATColors.transparent,
      child: Container(
        height: 60, width: width,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ATColors.hex202020,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ATColors.hex2D2D2D),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(width: 8,),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: ATImgLoader(
                imgPath: programUrl ?? '',
                height: 40, width: 40,
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    peopleInLive,
                    style: TextStyle(
                      color: ATColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const ATImgLoader(
                        imgPath: ATImgStrings.filledBroadCast,
                        height: 15,
                        width: 15,
                      ),
                      Flexible(
                        child: _HorizontalScrollCards(
                          // spaceSize: constraints.maxWidth,
                          child: Text(
                            title ?? '',
                            style: TextStyle(
                              color: ATColors.hexC2C2C2,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                liveProgramOverlayKey.currentState?.dismissLiveProgram();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.close, color: ATColors.white, size: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class _HorizontalScrollCards extends StatelessWidget {
  const _HorizontalScrollCards({
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: <Widget>[child],
      options: CarouselOptions(
        aspectRatio: 15,
        autoPlay: true,
        viewportFraction: 2,
        autoPlayAnimationDuration: const Duration(seconds: 5),
        scrollPhysics: const NeverScrollableScrollPhysics(),
        autoPlayCurve: Curves.linear,
        autoPlayInterval: const Duration(milliseconds: 50),
      ),
    );
  }
}
