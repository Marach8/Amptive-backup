import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';

class ProgramCardShimmer extends StatelessWidget {
  const ProgramCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget shimmerBox({required double height, required double width, double radius = 0}) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white, // Required for Shimmer.fromColors to apply the mask
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: ATColors.hex2D2D2D,
      highlightColor: ATColors.hex5B5B5B,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: Row(
                children: [
                  shimmerBox(height: 40, width: 40, radius: 20), // Avatar
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerBox(height: 14, width: 140, radius: 4), // Title
                        const SizedBox(height: 8),
                        shimmerBox(height: 12, width: 90, radius: 4), // Subtitle
                      ],
                    ),
                  ),
                  shimmerBox(height: 10, width: 24, radius: 4), // Trailing dots
                ],
              ),
            ),
            shimmerBox(
              height: context.screenWidth - 16,
              width: context.screenWidth,
              radius: 16,
            ),
          ],
        ),
      );
  }
}
