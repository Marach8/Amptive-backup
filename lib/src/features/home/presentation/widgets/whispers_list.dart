import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';

class ATWhispersWidget extends StatelessWidget {
  const ATWhispersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: 10,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (_, __) => Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          width: 326,
          decoration: ShapeDecoration(
            color: ATColors.white.withValues(alpha: 0.1),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 16,
                cornerSmoothing: 0.6,
              ),
            ),
          ),
          child: Column(
            children: <Widget>[
              const TileWithLeadingImage(
                title: 'karankabir',
                subtitle: 'Listener',
                diameter: 48,
                leadingImagePath: ATImgStrings.jpeg1,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Text(
                  'I got so excited whan Jack spoke spanish for just no reason, like what!!!!!!>😂😂😂',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5, // 24px line height (16 * 1.5)
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
