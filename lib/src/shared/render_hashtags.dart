import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class RenderHashTags extends StatelessWidget {
  const RenderHashTags({
    super.key,
    this.hashtags,
  });
  final List<HashTag>? hashtags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: (hashtags ?? <HashTag>[]).map(
        (HashTag hashTag) => IntrinsicWidth(
        child: Container(
          margin: const EdgeInsets.only(bottom: 15, right: 15),
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ATColors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
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
                    color: ATColors.hexA8A8A8,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    )
    .toList());
  }
}
