import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/custom_rebuilder_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../../../config/utils/colors.dart';
import '../../../../../../../config/utils/font_sizes.dart';
import '../../../../../../../shared/circle_avatar.dart';
import '../../../../../../../shared/image_loader_widget.dart';


class AmptiveExistingEventWidget extends StatelessWidget {
  const AmptiveExistingEventWidget({
    super.key,
    required this.trendingPicture,
    required this.imageHeight,
    required this.imageWidth,
    required this.eachButtonNotifier,
    required this.onTap
  });
  final String trendingPicture;
  final double imageHeight, imageWidth;
  final ValueNotifier<bool> eachButtonNotifier;
  final void Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    return AmptiveRebuilderWidget(
      notifier: eachButtonNotifier,
      builder: (_, bool isSelected, __) {
        return ATContainer(
          onTap: () => onTap(isSelected),
          radius: 5,
          border: Border.all(
            color: isSelected ? ATColors.hex307FE2 : ATColors.transparent,
            width: 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ATContainer(
                radius: 5, height: imageHeight,
                width: imageWidth,
                clipBehavior: Clip.hardEdge,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: ATImgLoader(
                    boxFit: BoxFit.fill,
                    imgPath: trendingPicture
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                maxLines: 2,
                "We Can Do Hard Things",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'glendonnoyle',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: ATSizes.size13,
                        color: ATColors.hexA8A8A8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ATCircleAvatar(
                      diameter: 5,
                      color: ATColors.hexA8A8A8,
                    ),
                  ),
                  Text(
                    'LIVE',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ATColors.hexA8A8A8,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}