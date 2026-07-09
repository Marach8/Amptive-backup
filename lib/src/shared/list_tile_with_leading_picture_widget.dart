import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TileWithLeadingImage extends StatelessWidget {
  const TileWithLeadingImage(
      {super.key,
      this.trailingOnPressed,
      this.onAvatarOrTextPressed,
      required this.title,
      required this.subtitle,
      this.padding,
      this.diameter,
      required this.leadingImagePath});

  final VoidCallback? trailingOnPressed;
  final VoidCallback? onAvatarOrTextPressed;
  final String title, subtitle, leadingImagePath;
  final EdgeInsetsGeometry? padding;
  final double? diameter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(0, 15, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onAvatarOrTextPressed,
              child: Row(
                children: <Widget>[
                  leadingImagePath.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: ATImgLoader(
                            imgPath: leadingImagePath,
                            height: diameter ?? 40,
                            width: diameter ?? 40,
                            boxFit: BoxFit.cover,
                          ),
                        )
                      : ClipOval(
                          child: SvgPicture.string(
                            ATImgStrings.defaultAvatarSvg,
                            height: diameter ?? 40,
                            width: diameter ?? 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: context.textTheme.bodySmall?.copyWith(
                              color: ATColors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          trailingOnPressed == null
              ? const SizedBox.shrink()
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: trailingOnPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      ATImgStrings.moreHorizontalFilledIcon,
                      width: 30,
                      height: 30,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
