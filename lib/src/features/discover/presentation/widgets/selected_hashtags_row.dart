import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedHashtagsRow extends StatelessWidget {
  const SelectedHashtagsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedHashTagsCubit, List<HashTag>>(
      builder: (_, List<HashTag> selectedHashtags) {
        return ATAnimatedXFade(
          condition: selectedHashtags.isNotEmpty,
          duration: 220,
          fadeCurve: Curves.easeOut,
          sizeCurve: Curves.easeOutCubic,
          secondChild: const SizedBox.shrink(),
          firstChild: Container(
            width: double.infinity,
            height: 40, // Scaled up pill height
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 15,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(width: 0),
                  ...selectedHashtags.map((HashTag hashtag) 
                  => _SelectedHashtag(hashtag: hashtag)),
                  const SizedBox(width: 0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectedHashtag extends StatelessWidget {
  const _SelectedHashtag({ required this.hashtag});

  final HashTag hashtag;

  static const String _closeSvg = '''
<svg width="10" height="10" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3.76101 4.99997L0 8.76098L1.23899 9.99997L5 6.23896L8.76101 9.99997L10 8.76098L6.23899 4.99997L9.99997 1.23899L8.76098 0L5 3.76098L1.23902 0L2.50654e-05 1.23899L3.76101 4.99997Z" fill="white" fill-opacity="0.7"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Scaled up from 36
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 14, // scaled up radius slightly
            cornerSmoothing: 1,
          ),
        ),
        color: ATColors.white.withValues(alpha: 0.1),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 12, right: 6), // Right is 6 because InkWell has 6 padding
      child: Row(
        children: <Widget>[
          Text(
            '#${(hashtag.displayName ?? hashtag.name ?? '').replaceFirst(RegExp(r'^#+'), '')}',
            style: context.textTheme.labelSmall?.copyWith(
                fontSize: ATSizes.size12, // Scaled up from 11
                color: ATColors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(width: 4), // 4 gap + 6 InkWell padding = 10px visual gap
          InkWell(
            onTap: () =>
                context.read<SelectedHashTagsCubit>().removeHashtag(hashtag),
            splashColor: ATColors.hex303030,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SvgPicture.string(
                _closeSvg,
                width: 14,
                height: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

