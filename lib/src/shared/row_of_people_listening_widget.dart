import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:flutter/material.dart';

class PeopleListeningWidget extends StatelessWidget {
  const PeopleListeningWidget(
      {super.key,
      this.pictureDiameter,
      this.showNumberInsideContainer = false,
      this.viewerProfileUrls,
      this.totalViewerCount,
      this.animateAvatarChanges = false});

  final double? pictureDiameter;
  final bool showNumberInsideContainer;
  final bool animateAvatarChanges;
  final List<String>? viewerProfileUrls;
  final int? totalViewerCount;

  List<String> get _viewerImages {
    if (viewerProfileUrls != null && viewerProfileUrls!.isNotEmpty) {
      final int count = totalViewerCount ?? 0;
      final int visibleCount = count < 4 ? count : 4;
      return viewerProfileUrls!.take(visibleCount).toList();
    }
    return <String>[
      // ATImgStrings.jpeg1,
      // ATImgStrings.jpeg2,
      // ATImgStrings.jpeg3,
      // ATImgStrings.JOE_POMP_SHOW,
    ];
  }

  int get _displayCount {
    final int count = totalViewerCount ?? 0;
    return count > 4 ? count - 4 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      children: <Widget>[
        ATOverlappingImages(
          imgPaths: _viewerImages,
          imgSize: pictureDiameter ?? 35,
          overlapOffset: 15,
          borderWidth: 2,
          borderColor: ATColors.containerGradientColorB,
          animateChanges: animateAvatarChanges,
        ),
        showNumberInsideContainer && _displayCount > 0
            ? Positioned(
                right: 0,
                child: ATContainer(
                  color: ATColors.hex2D2D2D,
                  alignment: Alignment.center,
                  height: pictureDiameter ?? 35,
                  width: pictureDiameter ?? 35,
                  boxShape: BoxShape.circle,
                  child: Text('+${_displayCount}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: ATSizes.size13)),
                ))
            : const SizedBox.shrink()
      ],
    );
  }
}
