import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:figma_squircle/figma_squircle.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../shared/circle_avatar.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../shared/image_loader_widget.dart';

class GoLiveTypeSelectionWidget extends StatelessWidget {
  const GoLiveTypeSelectionWidget({
    super.key,
    required this.selectedImgPath,
    required this.unselectedImgPath,
    required this.subtitle,
    required this.alphabet,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.selectedRotationDegrees = 0,
    this.selectedVerticalOffset = 29,
  });

  final String selectedImgPath, unselectedImgPath, title, subtitle, alphabet;
  final bool isSelected;
  final double selectedRotationDegrees;
  final double selectedVerticalOffset;
  final void Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(isSelected),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipSmoothRect(
            radius: SmoothBorderRadius(
              cornerRadius: 5,
              cornerSmoothing: 0.8,
            ),
            child: ATContainer(
              duration: 300,
              curve: Curves.easeOutCubic,
              height: 120,
              width: double.infinity,
              radius: 0,
              alignment: Alignment.center,
              color: isSelected
                  ? const Color(0xFFFF0078)
                  : const Color(0xFF1F1F23),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: isSelected ? 1 : 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                builder: (BuildContext context, double progress, _) {
                  final double scale = 0.52 + (0.88 * progress);
                  return Transform.translate(
                    offset: Offset(0, selectedVerticalOffset * progress),
                    child: Transform.rotate(
                      angle:
                          (selectedRotationDegrees * math.pi / 180) * progress,
                      child: Transform.scale(
                        scale: scale,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Opacity(
                              opacity: 1 - progress,
                              child: ATImgLoader(
                                imgPath: unselectedImgPath,
                                height: 149,
                                width: 165,
                                boxFit: BoxFit.contain,
                              ),
                            ),
                            Opacity(
                              opacity: progress,
                              child: ATImgLoader(
                                imgPath: selectedImgPath,
                                height: 149,
                                width: 165,
                                boxFit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ATCircleAvatar(
                animationDuration: 200,
                diameter: 15,
                color:
                    isSelected ? const Color(0xFFFD6481) : ATColors.hex2D2D2D,
                child: FittedBox(child: Text(alphabet)),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: ATSizes.size14),
              )
            ],
          ),
          const SizedBox(height: 7),
          Text(
            maxLines: 2,
            subtitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ATColors.hexC2C2C2,
                  fontSize: ATSizes.size13,
                ),
          )
        ],
      ),
    );
  }
}
