import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RenderHashTags extends StatelessWidget {
  const RenderHashTags({
    super.key,
    this.hashtags,
  });
  final List<HashTag>? hashtags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: (hashtags ?? <HashTag>[])
            .map(
              (HashTag hashTag) => IntrinsicWidth(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15, right: 15),
                  child: Material(
                    color: ATColors.white.withValues(alpha: 0.1),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 10,
                        cornerSmoothing: 0.8,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.pushNamed(
                        ATRoutes.SOCIETY_HASHTAG_SCREEN,
                        extra: hashTag.name,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                        child: Row(
                          children: <Widget>[
                            const ATImgLoader(
                              imgPath: ATImgStrings.hashIcon,
                              height: 16,
                              width: 16,
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                hashTag.name ?? '',
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: ATColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList());
  }
}
