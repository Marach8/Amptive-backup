import 'package:flutter/material.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/search_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/host.dart';


class TrendingHashtagsList extends StatelessWidget {
  const TrendingHashtagsList({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HashtagServiceBloc, (List<ATHashtag<bool>>, List<ATHashtag<bool>>), List<ATHashtag<bool>>>(
      selector: ((List<ATHashtag<bool>>, List<ATHashtag<bool>>) state) => state.$1,
      builder: (_, List<ATHashtag<bool>> hashtags) {
        if(hashtags.isEmpty){
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.NO_TRENDING_HASHTAGS,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: ATFontSizes.size16
                  )
                ),
                const SizedBox(height: 5,),
                Text(
                  maxLines: 2,
                  ATStrings.SEARCH_UR_HASHTAGS,
                  style: context.textTheme.bodySmall?.copyWith(color: ATColors.hexC2C2C2),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (_, BoxConstraints kst) {
            return ATScrollBar(
              scrollController: scrollController,
              child: ListView.builder(
                controller: scrollController,
                itemCount: hashtags.length + 1,
                padding: const EdgeInsets.only(right: 10, bottom: 100),
                itemBuilder: (_, int index){
                  if(index == 0){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Text(
                        ATStrings.TRENDING_HASHTAGS,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: ATFontSizes.size16
                        )
                      ),
                    );
                  }

                  final ATHashtag<bool> hashtag = hashtags.elementAt(index - 1);
                  return HashtagWithCheckIconWidget(hashtag: hashtag,);
                },
              )
            );
          }
        );
      }
    );
  }
}



class HashtagWithCheckIconWidget extends StatelessWidget {
  const HashtagWithCheckIconWidget({
    super.key,
    required this.hashtag,
  });

  final ATHashtag<bool> hashtag;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      radius: 10,
      onTap: (){
        if(hashtag.notifier.value ?? false){
          context.read<HashtagServiceBloc>().removeHashtag(hashtag);
        }
        else{
          context.read<HashtagServiceBloc>().addHashtag(hashtag);
        }
      },
      padding: const EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          const ATHashtagBadge(badgeSize: 50, hashSize: 28,),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ATFilterWidget<SearchkeyBloc>(
                  title: '#${hashtag.title ?? ''}',
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: ATFontSizes.size15
                  )
                ),
                Text(
                  hashtag.subtitle ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: ATColors.hexC2C2C2,
                    fontSize: ATFontSizes.size13
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool?>(
            valueListenable: hashtag.notifier,
            builder: (_, bool? isSelected, __) {
              return ATContainer(
                duration: 200,
                color: (isSelected ?? false) ? ATColors.white : ATColors.trsprnt,
                border: Border.all(color: ATColors.white),
                boxShape: BoxShape.circle,
                height: 24, width: 24,
                child: Icon(
                  Icons.check, size: 20,
                  color: (isSelected ?? false) ? ATColors.hex0D0D0D : ATColors.trsprnt
                )
              );
            }
          )
        ],
      ),
    );
  }
}