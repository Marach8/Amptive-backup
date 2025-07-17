import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/overlapping_images.dart';
import 'package:flutter/material.dart';

class PeopleListeningWidget extends StatelessWidget {

  const PeopleListeningWidget({
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
        const ATOverlappingImages(
          imgPaths: <String>[ATImgStrings.jpeg1, ATImgStrings.jpeg2, ATImgStrings.jpeg3, ATImgStrings.JOE_POMP_SHOW],
          imgSize: 30, overlapOffset: 25, borderWidth: 1,
        ),
    
        showNumberInsideContainer ? Positioned(
          right: 0,
          child: ATContainer(
            color: ATColors.hex2D2D2D,
            alignment: Alignment.center,
            height: 30, width: 30,
            boxShape: BoxShape.circle,
            child: Text(
              '+652',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: ATFontSizes.size13
              )
            ),
          )
        ) : const SizedBox.shrink()
      ],
    );
  }
}


        // showNumberInsideContainer ? const SizedBox.shrink() : Container(
        //   margin: const EdgeInsets.only(left: 46),
        //   child: Text(
        //     '656 listening',
        //     style: Theme.of(context).textTheme.titleMedium?.copyWith(
        //       fontSize: ATFontSizes.size13
        //     )
        //   ),
        // )