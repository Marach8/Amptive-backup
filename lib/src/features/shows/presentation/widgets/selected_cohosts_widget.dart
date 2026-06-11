import 'dart:ui';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class SelectedCoHostsWidget extends StatelessWidget {
  const SelectedCoHostsWidget({
    super.key,
    required this.selectedCohosts,
    required this.onEdit,
  });

  final List<User> selectedCohosts;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final Iterable<String> cohostNames =
        selectedCohosts.map((User cohost) => cohost.username ?? '');

    return ATContainer(
      radius: 14,
      padding: const EdgeInsets.all(15),
      color: ATColors.white.withValues(alpha: 0.1),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _OverlappingCohosts(cohosts: selectedCohosts),
              ),
              const SizedBox(
                width: 20,
              ),
              ATContainer(
                onTap: onEdit,
                radius: 5,
                color: ATColors.white.withValues(alpha: 0.1),
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Text(
                  ATStrings.editCohost,
                  style: context.textTheme.labelSmall?.copyWith(
                      color: ATColors.white.withValues(alpha: 0.7),
                      height: 1.1),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            '${cohostNames.join(', ')} will be notified',
            maxLines: 5,
            style: context.textTheme.labelSmall?.copyWith(
              color: ATColors.white.withValues(alpha: 0.6),
              fontSize: ATSizes.size13,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlappingCohosts extends StatelessWidget {
  const _OverlappingCohosts({
    required this.cohosts,
    this.imgSize = 42.0,
    this.overlapOffset = 32.0,
    this.borderWidth = 1,
    this.borderColor,
  });

  final List<User> cohosts;
  final double imgSize;
  final Color? borderColor;
  final double overlapOffset, borderWidth;

  static const int maxSlots = 5;

  @override
  Widget build(BuildContext context) {
    const int visibleCount = maxSlots;
    final double width = imgSize + ((visibleCount - 1) * overlapOffset);

    return SizedBox(
      height: imgSize,
      width: width,
      child: Stack(
        children: List<Widget>.generate(visibleCount, (int index) {
          final bool hasUser = index < cohosts.length;

          return Positioned(
            left: index * overlapOffset,
            child: ATContainer(
              height: imgSize,
              width: imgSize,
              color: ATColors.black.withValues(alpha: 0.05),
              clipBehavior: Clip.hardEdge,
              radius: imgSize,
              border: Border.all(
                color: borderColor ?? ATColors.white.withValues(alpha: 0.4),
                width: borderWidth,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: hasUser
                    ? ATImgLoader(
                        imgPath: cohosts[index].profilePicture ?? '',
                        height: imgSize,
                        width: imgSize,
                        boxFit: BoxFit.cover,
                      )
                    : BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: context.textTheme.labelSmall?.copyWith(
                              fontSize: ATSizes.size11,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

