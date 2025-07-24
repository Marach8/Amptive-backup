import 'dart:ui';

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';


class SelectedCoHostsWidget extends StatelessWidget {
  const SelectedCoHostsWidget({
    super.key,
    required this.selectedCohosts,
    required this.onEdit,
  });

  final List<ATCohost<bool>> selectedCohosts;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final Iterable<String> cohostNames = selectedCohosts.where(
      (ATCohost<bool> cohost) => cohost.profilePicture != null
    ).map((ATCohost<bool> cohost) => cohost.username ?? '');

    return ATContainer(
      radius: 14,
      padding: const EdgeInsets.all(10),
      color: ATColors.white.withValues(alpha: 0.1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OverlappingCohosts<bool>(
                  cohosts: selectedCohosts
                ),
                const SizedBox(height: 5,),
                Text(
                  '${cohostNames.join(', ')} will be notified',
                  maxLines: 5,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ATColors.white.withValues(alpha: 0.6),
                    fontSize: ATFontSizes.size13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18,),
          ATContainer(
            onTap: onEdit, radius: 5,
            color: ATColors.white.withValues(alpha: 0.1),
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Text(
              ATStrings.EDIT_COHOST,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: ATColors.white.withValues(alpha: 0.7),
                height: 1.1
              ),
            ),
          )
        ],
      ),
    );
  }
}


class OverlappingCohosts<T> extends StatelessWidget {

  const OverlappingCohosts({
    super.key,
    required this.cohosts,
    this.imgSize = 42.0,
    this.overlapOffset = 32.0,
    this.borderWidth = 1,
    this.borderColor,
  });


  final List<ATCohost<T>> cohosts;
  final double imgSize;
  final Color? borderColor;
  final double overlapOffset, borderWidth;

  @override
  Widget build(BuildContext context) {
    final int length = cohosts.length;
    final double width = imgSize + ((length - 1) * overlapOffset);

    return SizedBox(
      height: imgSize,
      width: width,
      child: Stack(
        children: cohosts.indexed.map(
          ((int, ATCohost<T>) entry) {
            return Positioned(
              left: entry.$1 * overlapOffset,
              child: ATContainer(
                height: imgSize, width: imgSize,
                color: ATColors.black.withValues(alpha: 0.05),
                clipBehavior: Clip.hardEdge,
                radius: imgSize,
                border: Border.all(
                  color: borderColor ?? ATColors.white,
                  width: borderWidth,
                ) ,
                child: entry.$2.profilePicture != null ? ATImgLoader(
                  imgPath: entry.$2.profilePicture!,
                  height: imgSize, width: imgSize,
                  boxFit: BoxFit.cover,
                ) : ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Center(
                      child: Text(
                        (entry.$1 + 1).toString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: ATFontSizes.size11
                        )
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        ).toList(),
      ),
    );
  }
}