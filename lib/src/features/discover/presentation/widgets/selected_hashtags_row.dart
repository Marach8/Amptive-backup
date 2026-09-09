import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedHashtagsRow extends StatelessWidget {
  const SelectedHashtagsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedHashTagsCubit, List<HashTag>>(
      builder: (_, List<HashTag> selectedHashtags) {
        return ATAnimatedXFade(
          condition: selectedHashtags.isNotEmpty,
          secondChild: const SizedBox.shrink(),
          firstChild: SizedBox(
            height: 45,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 15),
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 0.1,),
                  ...selectedHashtags.map((HashTag hashtag) 
                  => _SelectedHashtag(hashtag: hashtag)),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ATColors.white.withValues(alpha: 0.1),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: <Widget>[
          Text(
            (hashtag.displayName ?? hashtag.name ?? '').toLowerCase(),
            style: context.textTheme.labelSmall?.copyWith(
                fontSize: ATSizes.size11,
                color: ATColors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () =>
                context.read<SelectedHashTagsCubit>().removeHashtag(hashtag),
            splashColor: ATColors.hex303030,
            borderRadius: BorderRadius.circular(6),
            child: Icon(
              Icons.close,
              size: 15,
              color: ATColors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

