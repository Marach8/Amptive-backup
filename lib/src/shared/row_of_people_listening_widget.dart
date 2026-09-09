import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:flutter/material.dart';

class PeopleListeningWidget extends StatelessWidget {
  const PeopleListeningWidget(
      {super.key,
      this.pictureDiameter,
      this.showNumberInsideContainer = false,
      this.viewerProfileUrls,
      this.totalViewerCount});

  final double? pictureDiameter;
  final bool showNumberInsideContainer;
  final List<String>? viewerProfileUrls;
  final int? totalViewerCount;

  List<String> get _viewerImages {
    if (viewerProfileUrls != null && viewerProfileUrls!.isNotEmpty) {
      return viewerProfileUrls!.take(4).toList();
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
          overlapOffset: 25,
          borderWidth: 1,
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
                  child: Text('+$_displayCount',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 13)),
                ))
            : const SizedBox.shrink()
      ],
    );
  }
}



class PeopleListeningOrGoing extends StatelessWidget {
  const PeopleListeningOrGoing({
    super.key, required this.item});
  final HomeFeedItem item;

  @override
  Widget build(BuildContext context) {
    final List<String> images = item.avatarUrls ?? <String>[];
    final String listenersCount = item.viewerCount.compactFormat;
    final String goingCount = item.goingCount.compactFormat;

    final String text = listenersCount.isNotEmpty ? '$listenersCount listening'
      : goingCount.isNotEmpty ? '$goingCount going' : '';
    return Row(
      spacing: 10,
      children: <Widget>[
        ATOverlappingImages(
          imgPaths: images.take(4).toList(),
          imgSize: 35,
          overlapOffset: 25,
          borderWidth: 1,
        ),
        Text(
          text,
          style: context.textTheme.bodySmall
            ?.copyWith(fontSize: 13)),
      ]
    );
  }
}


class PeopleListeningWithNumberStacked extends StatelessWidget {
  const PeopleListeningWithNumberStacked({
    super.key,
    required this.images,
    required this.noOfListeners,
  });
  final List<String> images;
  final int noOfListeners;

  @override
  Widget build(BuildContext context) {
    final int treatedNo = noOfListeners - 4;

    return Stack(
      children: <Widget>[
        ATOverlappingImages(
          imgPaths: images.take(4).toList(),
          imgSize: 35,
          overlapOffset: 25,
          borderWidth: 1,
        ),
        if(treatedNo > 0)Positioned(
          right: 0,
          child: Container(
            alignment: Alignment.center,
            height: 35, width: 35,
            decoration: BoxDecoration(
              color: ATColors.hex2D2D2D,
              shape: BoxShape.circle,
            ),
            child: Text(
              '+${treatedNo.compactFormat}',
              style: context.textTheme.bodySmall
                ?.copyWith(fontSize: 13)),
          )
        )
      ]
    );
  }
}
