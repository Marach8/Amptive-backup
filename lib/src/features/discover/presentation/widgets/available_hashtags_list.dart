import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/all_hashtags_response_model.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/host.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/shows/presentation/widgets/cohost_with_check_icon.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class AvailableHashtagsList extends StatelessWidget {
//   const AvailableHashtagsList({
//     super.key,
//     required this.scrollController,
//   });

//   final ScrollController scrollController;

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<
//             HashtagServiceBloc,
//             (List<ATHashtag<bool>>, List<ATHashtag<bool>>),
//             List<ATHashtag<bool>>>(
//         selector: ((List<ATHashtag<bool>>, List<ATHashtag<bool>>) state) =>
//             state.$1,
//         builder: (_, List<ATHashtag<bool>> hashtags) {
//           if (hashtags.isEmpty) {
//             return Padding(
//               padding: const EdgeInsets.fromLTRB(15, 10, 15, 100),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(ATStrings.NO_TRENDING_HASHTAGS,
//                       style: context.textTheme.bodySmall
//                           ?.copyWith(fontSize: ATSizes.size16)),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     maxLines: 2,
//                     ATStrings.SEARCH_UR_HASHTAGS,
//                     style: context.textTheme.bodySmall
//                         ?.copyWith(color: ATColors.hexC2C2C2),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return LayoutBuilder(builder: (_, BoxConstraints kst) {
//             return ATScrollBar(
//                 child: ListView.builder(
//               controller: scrollController,
//               itemCount: hashtags.length + 1,
//               padding: const EdgeInsets.only(right: 10, bottom: 100),
//               itemBuilder: (_, int index) {
//                 if (index == 0) {
//                   return Padding(
//                     padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//                     child: Text(ATStrings.TRENDING_HASHTAGS,
//                         style: context.textTheme.bodySmall
//                             ?.copyWith(fontSize: ATSizes.size16)),
//                   );
//                 }

//                 final ATHashtag<bool> hashtag = hashtags.elementAt(index - 1);
//                 return HashtagWithCheckIconWidget(
//                   hashtag: hashtag,
//                 );
//               },
//             ));
//           });
//         });
//   }
// }

// class HashtagWithCheckIconWidget extends StatelessWidget {
//   const HashtagWithCheckIconWidget({
//     super.key,
//     required this.hashtag,
//   });

//   final ATHashtag<bool> hashtag;

//   @override
//   Widget build(BuildContext context) {
//     return ATContainer(
//       radius: 10,
//       onTap: () {
//         if (hashtag.notifier.value ?? false) {
//           context.read<HashtagServiceBloc>().removeHashtag(hashtag);
//         } else {
//           context.read<HashtagServiceBloc>().addHashtag(hashtag);
//         }
//       },
//       padding: const EdgeInsets.all(15),
//       child: Row(
//         children: <Widget>[
          // const ATHashtagBadge(
          //   badgeSize: 50,
          //   hashSize: 28,
          // ),
//           const SizedBox(
//             width: 10,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 ATFilterWidget<SearchkeyCubit>(
//                     title: '#${hashtag.title ?? ''}',
//                     style: context.textTheme.bodySmall
//                         ?.copyWith(fontSize: ATSizes.size15)),
//                 Text(
//                   hashtag.subtitle ?? '',
//                   style: context.textTheme.bodySmall?.copyWith(
//                       color: ATColors.hexC2C2C2, fontSize: ATSizes.size13),
//                 ),
//               ],
//             ),
//           ),
//           ValueListenableBuilder<bool?>(
//               valueListenable: hashtag.notifier,
//               builder: (_, bool? isSelected, __) {
//                 return ATContainer(
//                     duration: 200,
//                     color: (isSelected ?? false)
//                         ? ATColors.white
//                         : ATColors.transparent,
//                     border: Border.all(color: ATColors.white),
//                     boxShape: BoxShape.circle,
//                     height: 24,
//                     width: 24,
//                     child: Icon(Icons.check,
//                         size: 20,
//                         color: (isSelected ?? false)
//                             ? ATColors.hex0D0D0D
//                             : ATColors.transparent));
//               })
//         ],
//       ),
//     );
//   }
// }







class AvailableHashtagsList extends StatelessWidget {
  const AvailableHashtagsList({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllHashtagsCubit, ATAppState<AllHashtagsResponseModel>>(
        listener: (_, ATAppState<AllHashtagsResponseModel> state) {
      if (state is FailureState<AllHashtagsResponseModel>) {
        showAppNotification2(
            context: context,
            text: state.message,
            type: NotificationType.failure);
      }
    }, builder: (_, ATAppState<AllHashtagsResponseModel> state) {
      return switch (state) {
        InitialState<AllHashtagsResponseModel>() => const SizedBox.shrink(),
        LoadingState<AllHashtagsResponseModel>() ||
        FailureState<AllHashtagsResponseModel>() ||
        SuccessState<AllHashtagsResponseModel>() =>
          Builder(
            builder: (_) {
              final AllHashtagsResponseModel? hashtagsData =
                  context.read<AllHashtagsCubit>().currentTagsData;
              final List<HashTag> hashtags = hashtagsData?.hashtags ?? <HashTag>[];

              if (hashtags.isEmpty) {
                if (state is LoadingState<AllHashtagsResponseModel>) {
                  return CohosListInitialLoadingShimmer(
                    text: ATStrings.trendingHashtags,
                    scrollController: scrollController,
                  );
                }
                if (state is FailureState<AllHashtagsResponseModel>) {
                  return Center(
                      child: IconButton(
                    onPressed: () {
                      context.read<AllHashtagsCubit>().fetchHashTags();
                    },
                    icon: const Icon(Icons.refresh),
                  ));
                }
                return const Center(child: Text('No hashtags available yet'));
              }

              final bool hasMore = hashtagsData?.hasMore ?? false;
              final int count =
                  hasMore ? hashtags.length + 2 : hashtags.length + 1;

              return BlocBuilder<SelectedHashTagsCubit, List<HashTag>>(
                  builder: (_, List<HashTag> selectedHashtags) {
                return ListView.builder(
                  itemCount: count,
                  controller: scrollController,
                  padding: const EdgeInsets.only(right: 10, bottom: 20),
                  itemBuilder: (_, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text(ATStrings.trendingHashtags,
                            style: context.textTheme.bodySmall
                                ?.copyWith(fontSize: ATSizes.size16)),
                      );
                    }

                    final int adjustedIndex = index - 1;
                    if (adjustedIndex < hashtags.length) {
                      final HashTag hashtag = hashtags[adjustedIndex];
                      final bool isLastItem =
                          adjustedIndex == hashtags.length - 1;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLastItem ? 100 : 0),
                        child: HastagWithCheckIconWidget(
                          hashtag: hashtag,
                          key: ValueKey<String?>(hashtag.id),
                          isSelected: selectedHashtags.contains(hashtag),
                          onTap: (bool isSelected) {
                            if (isSelected) {
                              context.read<SelectedHashTagsCubit>()
                                .removeHashtag(hashtag);
                            } else {
                              context.read<SelectedHashTagsCubit>()
                                .addHashtag(hashtag);
                            }
                          },
                        ),
                      );
                    }

                    if (state is LoadingState<AllHashtagsResponseModel>) {
                      return const CohostWithCheckIconShimmer();
                    }
                    return const SizedBox.shrink();
                  },
                );
              });
            },
          )
      };
    });
  }
}

class SelectedHashTagsCubit extends Cubit<List<HashTag>> {
  SelectedHashTagsCubit({this.initialHashtags})
      : super(initialHashtags ?? <HashTag>[]);

  final List<HashTag>? initialHashtags;

  void addHashtag(HashTag hashtag) {
    if (state.length == 5) return;

    emit(<HashTag>[...state, hashtag]);
  }

  void removeHashtag(HashTag hashtagToRemove) {
    emit(state.where((HashTag hashtag) 
      => hashtag.id != hashtagToRemove.id).toList());
  }
}



class HastagWithCheckIconWidget extends StatelessWidget {
  const HastagWithCheckIconWidget({
    super.key,
    required this.hashtag,
    required this.isSelected,
    required this.onTap,
  });

  final HashTag hashtag;
  final bool isSelected;
  final ValueChanged<bool> onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      radius: 10,
      onTap: () => onTap(isSelected),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          const ATHashtagBadge(
            badgeSize: 50,
            hashSize: 28,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ATFilterWidget<SearchkeyCubit>(
                    title: (hashtag.displayName ?? '').toLowerCase(),
                    style: context.textTheme.bodySmall
                        ?.copyWith(fontSize: 15)),
                ATFilterWidget<SearchkeyCubit>(
                  title: hashtag.name ?? '',
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: ATColors.hexC2C2C2, fontSize: 13),
                ),
              ],
            ),
          ),
          AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? ATColors.white : ATColors.transparent,
                border: Border.all(color: ATColors.white),
                shape: BoxShape.circle,
              ),
              height: 24,
              width: 24,
              child: Icon(Icons.check,
                  size: 20,
                  color: isSelected ? ATColors.hex0D0D0D 
                    : ATColors.transparent))
        ],
      ),
    );
  }
}
