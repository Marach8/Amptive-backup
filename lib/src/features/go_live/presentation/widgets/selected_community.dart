import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class SelectedCommunityWidget extends StatelessWidget {
  const SelectedCommunityWidget({
    super.key,
    required this.selectedCommunity,
    this.onClose,
    required this.onView,
  });

  final Community selectedCommunity;
  final VoidCallback onView;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(cornerRadius: 14, cornerSmoothing: 0.8),
      child: ColoredBox(
        color: ATColors.white.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipSmoothRect(
                radius: SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 0.8),
                child: ATImgLoader(
                  imgPath: selectedCommunity.image ?? '',
                  boxFit: BoxFit.cover,
                  width: 100,
                  height: 75,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      selectedCommunity.name!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: ATSizes.size15),
                    ),
                    const SizedBox(height: 14),
                    // Transparent vertical hit padding keeps the tap target
                    // ~44px tall while the visible pill stays compact.
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onView,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ClipSmoothRect(
                          radius: SmoothBorderRadius(
                              cornerRadius: 6, cornerSmoothing: 0.8),
                          child: ColoredBox(
                            color: ATColors.white.withValues(alpha: 0.1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Text(
                                ATStrings.VIEW_COMMUNITY,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: ATColors.white
                                            .withValues(alpha: 0.7),
                                        height: 1.1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (onClose != null) ...<Widget>[
                const SizedBox(width: 10),
                InkWell(
                  onTap: onClose,
                  splashColor: ATColors.hex303030,
                  borderRadius: BorderRadius.circular(30),
                  child: const SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: ATImgLoader(
                        imgPath: ATImgStrings.recentRemoveXIcon,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
