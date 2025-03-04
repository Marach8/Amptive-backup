import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/font_sizes.dart';
import '../../../../../common_widgets/circle_avatar.dart';
import '../../../../../common_widgets/image_loader_widget.dart';


class AmptiveExistingEventWidget extends StatelessWidget {
  final String trendingPicture;
  final double imageHeight, imageWidth;
  final ValueNotifier<bool> eachButtonNotifier;
  final void Function(bool) onTap;
  const AmptiveExistingEventWidget({
    super.key,
    required this.trendingPicture,
    required this.imageHeight,
    required this.imageWidth,
    required this.eachButtonNotifier,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveRebuilderWidget(
      notifier: eachButtonNotifier,
      builder: (_, isSelected, __) {
        return ATContainer(
          onTap: () => onTap(isSelected),
          radius: 5,
          border: Border.all(
            color: isSelected ? ATColors.hex307FE2 : ATColors.transparentColor,
            width: 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ATContainer(
                radius: 5, height: imageHeight,
                width: imageWidth,
                clipBehavior: Clip.hardEdge,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: AmptiveImageLoaderWidget(
                    boxFit: BoxFit.fill,
                    imagePath: trendingPicture
                  ),
                ),
              ),
              const Gap(5),
              Text(
                maxLines: 2,
                "We Can Do Hard Things",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'glendonnoyle',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: AmptiveFontSizes.size13,
                        color: ATColors.grey5Color,
                      ),
                    ),
                  ),
                  const Gap(5),
                  
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AmptiveCircleAvatarWidget(
                      diameter: 5,
                      color: ATColors.grey5Color,
                    ),
                  ),
                  Text(
                    'LIVE',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ATColors.grey5Color,
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