import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/all_hashtags_response_model.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/shows/presentation/widgets/cohost_with_check_icon.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';

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
              final List<HashTag> hashtags = List<HashTag>.from(hashtagsData?.hashtags ?? <HashTag>[]);

              final String rawQuery = context.read<SearchkeyCubit>().state.trim();
              final String query = rawQuery.replaceFirst(RegExp(r'^#+'), '');
              final bool isSearching = rawQuery.isNotEmpty;

              if (isSearching && query.isNotEmpty) {
                final bool isValidForCreation = query.length <= 25 && RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(query);
                
                if (isValidForCreation) {
                  final bool exists = hashtags.any((HashTag h) => 
                    (h.name ?? '').replaceFirst(RegExp(r'^#+'), '').toLowerCase() == query.toLowerCase());
                  if (!exists) {
                    hashtags.insert(0, HashTag(
                      id: 'new_${query.toLowerCase()}',
                      name: query.toLowerCase(),
                      displayName: query,
                    ));
                  }
                }
              }

              if (hashtags.isEmpty) {
                if (state is LoadingState<AllHashtagsResponseModel> && !isSearching) {
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
                
                final String query = context.read<SearchkeyCubit>().state.trim();
                return Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Nothing to show here right now.',
                        style: context.textTheme.bodyMedium,
                      ),
                      if (query.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 4),
                        Text(
                          query.length > 25 
                              ? 'Hashtags cannot exceed 25 characters.'
                              : !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(query)
                                  ? 'Hashtags cannot contain spaces or special characters.'
                                  : 'Any hashtags matching "$query" will appear here.',
                          style: context.textTheme.labelSmall
                              ?.copyWith(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                );
              }

              final bool hasMore =
                  isSearching ? (hashtagsData?.hasMore ?? false) : false;
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
                      final bool showingSearchResults = isSearching;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text(
                            showingSearchResults
                                ? 'Search Results'
                                : ATStrings.trendingHashtags,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: ATSizes.size16,
                              fontWeight: FontWeight.w600,
                            )),
                      );
                    }

                    final int adjustedIndex = index - 1;
                    if (adjustedIndex < hashtags.length) {
                      final HashTag hashtag = hashtags[adjustedIndex];
                      final bool isLastItem = (adjustedIndex == hashtags.length - 1)
                        && state is! LoadingState<AllHashtagsResponseModel>;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLastItem ? 100 : 0),
                        child: _CreatableHashtagItem(
                          hashtag: hashtag,
                          key: ValueKey<String?>(hashtag.id),
                          isSelected: selectedHashtags.any((HashTag h) => 
                              h.id == hashtag.id || 
                              (h.name ?? '').toLowerCase() == (hashtag.name ?? '').toLowerCase()),
                        ),
                      );
                    }

                    if (state is LoadingState<AllHashtagsResponseModel> && !isSearching) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 100),
                        child: CohostWithCheckIconShimmer(),
                      );
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
      => hashtag.id != hashtagToRemove.id &&
         (hashtag.name ?? '').toLowerCase() != (hashtagToRemove.name ?? '').toLowerCase()
    ).toList());
  }

  /// Swaps a temporary (`new_…`) tag for the real one the server returned,
  /// so the show is created with a valid tag id rather than the placeholder.
  void replaceHashtag(HashTag oldTag, HashTag newTag) {
    emit(state
        .map((HashTag h) => h.id == oldTag.id ? newTag : h)
        .toList());
  }
}

class _CreatableHashtagItem extends StatelessWidget {
  const _CreatableHashtagItem({
    super.key,
    required this.hashtag,
    required this.isSelected,
  });

  final HashTag hashtag;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return HastagWithCheckIconWidget(
      hashtag: hashtag,
      isSelected: isSelected,
      onTap: (bool selected) async {
        final SelectedHashTagsCubit selectedCubit =
            context.read<SelectedHashTagsCubit>();
        if (selected) {
          selectedCubit.removeHashtag(hashtag);
        } else {
          selectedCubit.addHashtag(hashtag);

          // A brand-new tag carries a temporary "new_…" id. Create it on the
          // server and swap in the real id, otherwise the show is submitted
          // with an unresolvable tag id and the API 500s.
          if (hashtag.id != null && hashtag.id!.startsWith('new_')) {
            final ApiResponse<HashTag> res =
                await DiscoverRepoImpl().createHashtag(
              name: hashtag.name ?? '',
              displayName: hashtag.displayName ?? '',
            );
            res.when(
              successful: (Successful<HashTag> data) {
                final HashTag? created = data.data;
                if (created != null &&
                    (created.id?.isNotEmpty ?? false) &&
                    !created.id!.startsWith('new_')) {
                  selectedCubit.replaceHashtag(hashtag, created);
                }
              },
              unSuccessful: (Unsuccessful<HashTag> _) {},
            );
          }
        }
      },
    );
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
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: <Widget>[
          const ATImgLoader(
            imgPath: ATImgStrings.hashtagCircleIcon,
            height: 50,
            width: 50,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ATFilterWidget<SearchkeyCubit>(
                    title: '#${(hashtag.displayName ?? hashtag.name ?? '').replaceFirst(RegExp(r'^#+'), '')}',
                    style: context.textTheme.bodyMedium
                        ?.copyWith(fontSize: ATSizes.size15)),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Hashtag',
                  style: context.textTheme.titleSmall?.copyWith(
                      color: ATColors.hexC2C2C2, 
                      fontWeight: ATFontWeights.w500,
                      fontSize: ATSizes.size13),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? ATColors.white : ATColors.transparent,
                border: Border.all(color: ATColors.white, width: 2),
                shape: BoxShape.circle,
              ),
              height: 24,
              width: 24,
              child: Icon(Icons.check,
                  size: 20,
                  color: isSelected ? ATColors.hex0D0D0D 
                      : ATColors.transparent)),
        ],
      ),
    );
  }
}
