import 'dart:ui';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/config/utils/extensions/num_extensions.dart';

class NoOfListenersWidget extends StatelessWidget {
  const NoOfListenersWidget(
      {super.key,
      this.pictureDiameter,
      this.avatarUrls = const [],
      this.totalCount = 0,
      this.showNumberInsideContainer = false,
      this.fillMissingAvatars = true});

  final double? pictureDiameter;
  final bool showNumberInsideContainer;
  final bool fillMissingAvatars;
  final List<String> avatarUrls;
  final int totalCount;

  List<String> get _displayAvatars {
    final int visibleAvatarCount = totalCount < 4 ? totalCount : 4;
    final List<String> urls = List<String>.from(avatarUrls)
      ..removeWhere((String url) => url.trim().isEmpty);
    final List<String> placeholders = <String>[
      ATImgStrings.jpeg1,
      ATImgStrings.jpeg2,
      ATImgStrings.jpeg3,
      ATImgStrings.JOE_POMP_SHOW
    ];
    int i = 0;
    while (fillMissingAvatars && urls.length < visibleAvatarCount) {
      urls.add(placeholders[i % placeholders.length]);
      i++;
    }
    return urls.take(visibleAvatarCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = ATColors.containerGradientColorB;
    try {
      final state = context.watch<DominantColorCubit>().state;
      if (state is DominantColorLoaded) {
        borderColor = state.dominantColor;
      }
    } catch (_) {}

    return Stack(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      children: <Widget>[
        ATOverlappingImages(
            imgPaths: _displayAvatars,
            imgSize: 40,
            overlapOffset: 17,
            borderWidth: 2,
            borderColor: borderColor),
        if (totalCount > _displayAvatars.length)
          Positioned(
              right: -30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: ATContainer(
                    color: ATColors.black.withValues(alpha: 0.1),
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    boxShape: BoxShape.circle,
                    child: FittedBox(
                      child: Text(
                          '+${(totalCount - _displayAvatars.length).compactFormat}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: ATSizes.size11)),
                    ),
                  ),
                ),
              )),
      ],
    );
  }
}
