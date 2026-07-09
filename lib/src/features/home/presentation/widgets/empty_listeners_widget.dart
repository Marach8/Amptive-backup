import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:amptive/src/shared/worm_animated_circles.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class EmptyListenersWidget extends StatelessWidget {
  const EmptyListenersWidget({super.key, required this.isLive, this.hashCodeForSentence});

  final bool isLive;
  final int? hashCodeForSentence;

  @override
  Widget build(BuildContext context) {
    Color? borderColor;
    try {
      final state = context.watch<DominantColorCubit>().state;
      if (state is DominantColorLoaded) {
        borderColor = state.dominantColor;
      }
    } catch (_) {}

    final List<String> liveSentences = [
      'Be the First to Join!',
      'Grab your spot now!',
      'Tap to jump in!',
      "Don't miss out, join in!"
    ];
    final List<String> scheduledSentences = [
      'Be the First to RSVP!',
      'Secure your spot now!',
      'Set your reminder!',
      'RSVP before it starts!'
    ];

    final int sentenceIndex = (hashCodeForSentence ?? 0).abs() % 4;
    final String currentText = isLive ? liveSentences[sentenceIndex] : scheduledSentences[sentenceIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            WormAnimatedCircles(
              userAvatarUrl: context.read<LocalUserDataCubit>().currentUserData?.pictureUrl ?? '',
              borderColor: borderColor,
            ),
            const SizedBox(width: 8),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.white,
              loop: 1,
              child: Text(
                currentText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: ATSizes.size14,
                      fontWeight: ATFontWeights.w500,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}
