import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import '../../../../shared/image_loader_widget.dart';

class CommunityCardWidget extends StatelessWidget {
  const CommunityCardWidget({
    super.key,
    required this.picture,
    this.title,
    this.semanticLabel,
    this.padding,
    this.onTap,
    this.width = 170,
    this.height = 122,
  });

  final String picture;
  final String? title, semanticLabel;
  final double width, height;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: semanticLabel ?? title,
      child: ATContainer(
        width: width,
        height: height,
        margin: padding ?? const EdgeInsets.only(right: 12),
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 6,
            cornerSmoothing: 0.8,
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ATImgLoader(
                  imgPath: picture,
                  width: width,
                  height: height,
                  boxFit: BoxFit.cover,
                ),
              ),
              if (title != null) ...<Widget>[
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          Color(0xCC000000),
                        ],
                        stops: <double>[0.35, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Text(
                    title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
              if (onTap != null)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      splashColor: Colors.white.withValues(alpha: 0.14),
                      highlightColor: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
