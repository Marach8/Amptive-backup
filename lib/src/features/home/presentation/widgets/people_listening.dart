import 'dart:ui';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/overlapping_images.dart';
import 'package:flutter/material.dart';

class NoOfListenersWidget extends StatelessWidget {

  const NoOfListenersWidget({
    super.key,
    this.pictureDiameter,
    this.showNumberInsideContainer = false
  });
  
  final double? pictureDiameter;
  final bool showNumberInsideContainer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      children: <Widget>[
        ATOverlappingImages(
          imgPaths: const <String>[ATImgStrings.jpeg1, ATImgStrings.jpeg2, ATImgStrings.jpeg3, ATImgStrings.JOE_POMP_SHOW],
          imgSize: 42, overlapOffset: 30, borderWidth: 1,
          borderColor: ATColors.white.withValues(alpha: 0.4)
        ),
    
        Positioned(
          right: -30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: ATContainer(
                color: ATColors.black.withValues(alpha: 0.1),
                alignment: Alignment.center,
                height: 43, width: 43,
                boxShape: BoxShape.circle,
                child: FittedBox(
                  child: Text(
                    '+652',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: ATFontSizes.size11
                    )
                  ),
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
}
