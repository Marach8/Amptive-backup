import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SelectedHashtagsRow extends StatelessWidget {
  const SelectedHashtagsRow({
    super.key,
    this.margin,
  });

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HashtagServiceBloc, (List<ATHashtag<bool>>, List<ATHashtag<bool>>), List<ATHashtag<bool>>>(
      selector: ((List<ATHashtag<bool>>, List<ATHashtag<bool>>) state) => state.$2,
      builder: (_, List<ATHashtag<bool>> selectedHashtags) {  
        
        return ATAnimatedXFade(
          condition: selectedHashtags.isNotEmpty,
          secondChild: const SizedBox.shrink(),
          firstChild: ATContainer(
            height: 45,
            margin: margin ?? const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 15),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: selectedHashtags.indexed.map(
                  ((int, ATHashtag<bool>) entry) => Padding(
                    padding: entry.$1 == (selectedHashtags.length - 1) ? 
                      const EdgeInsets.only(right: 15) : EdgeInsets.zero,
                    child: SelectedHashtag(hashtag: entry.$2),
                  )
                ).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SelectedHashtag extends StatelessWidget {
  const SelectedHashtag({super.key, required this.hashtag});

  final ATHashtag<bool> hashtag;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      height: 30, radius: 10,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      color: ATColors.white.withValues(alpha: 0.1),
      child: Row(
        children: <Widget>[
          Text(
            hashtag.title ?? '',
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: ATSizes.size11,
              color: ATColors.white.withValues(alpha: 0.7)
            ),
          ),
          const SizedBox(width: 6,),          
          InkWell(
            onTap: () => context.read<HashtagServiceBloc>().removeHashtag(hashtag),
            splashColor: ATColors.hex303030,
            borderRadius: BorderRadius.circular(6),
            child: Icon(Icons.close, size: 15, color: ATColors.white.withValues(alpha: 0.7),),
          ),
        ],
      ),
    );
  }
}