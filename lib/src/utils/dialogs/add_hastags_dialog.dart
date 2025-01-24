import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/models/hashtag.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/host.dart';
import '../../services/create_show/create_show_service.dart';
import '../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../constants/strings/other_strings.dart';

Future<Set<ObjectWithNotifier<Hashtag>>?> showAddHashtagDialog(
    BuildContext context) async {
  CreateShowService service = GetIt.I<CreateShowService>();
  final availableHashtags = service.hashTagListData;

  final focusNode = FocusNode();
  final controller = TextEditingController();
  final showSuffixIconNotifier = ValueNotifier(false);
  focusNode.addListener(() => focusNode.hasFocus
      ? showSuffixIconNotifier.value = true
      : showSuffixIconNotifier.value = false);

  final searchQueryNotifier = ValueNotifier('');

  return await showModalBottomSheet(
      backgroundColor: AmptiveColors.brandBlack,
      constraints: BoxConstraints.expand(
          height: AmptiveHelperFunctions.getScreenHeight(context)),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.viewInsetsOf(context).bottom, top: 20.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Platform.isAndroid
                              ? Icon(
                            Icons.keyboard_arrow_down,
                            color:
                            AmptiveColors.whiteColor.withOpacity(0.6),
                          )
                              : AmptiveCustomContainer(
                            margin:
                            const EdgeInsets.symmetric(vertical: 10),
                            radius: 5,
                            height: 4,
                            width: 30,
                            color:
                            AmptiveColors.whiteColor.withOpacity(0.6),
                            child: const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              AmptiveOtherStrings.ADD_HASHTAG,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Gap(60.w),
                            AmptiveRebuilderWidget(
                                notifier: service.selectedHashtagLength,
                                builder: (_, number, __) {
                                  return Text(
                                    '$number ${AmptiveOtherStrings.SELECTED}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                        color: AmptiveColors.hexC2C2C2),
                                  );
                                }),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                        child: Text(
                          maxLines: 5,
                          AmptiveOtherStrings.ADD_HASHTAG_DESC,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AmptiveColors.hexC2C2C2),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                        child: AmptiveTextFormFieldWidget(
                          disableBlueBorder: true,
                          controller: controller,
                          focusNode: focusNode,
                          onChanged: (text) {
                            searchQueryNotifier.value = text;
                          },
                          hintText: AmptiveOtherStrings.SEARCH_4_COHOSTS,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(Iconsax.search_normal_14),
                          ),
                          prefixConstraints: const BoxConstraints(maxWidth: 50),
                          suffixIcon: AmptiveRebuilderWidget(
                              shouldDispose: true,
                              notifier: showSuffixIconNotifier,
                              builder: (_, shouldShow, __) {
                                return AmptiveAnimatedCrossFadeWidget(
                                  condition: shouldShow,
                                  secondChild: const SizedBox.shrink(),
                                  firstChild: GestureDetector(
                                    onTap: () {
                                      controller.clear();
                                      searchQueryNotifier.value = '';
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(Icons.close, size: 20),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),

                      //Row of selected Hashtags

                      Align(
                        alignment: Alignment.center,
                        child: AmptiveRebuilderWidget(
                          notifier: service.selectedHashtagLength,
                          builder: (_, val, __) {
                            var value = service.selectedHashtags.value;
                            return AmptiveAnimatedCrossFadeWidget(
                              condition: value.isEmpty,
                              firstChild: const SizedBox.shrink(),
                              secondChild: SingleChildScrollView(
                                padding: const EdgeInsets.only(bottom: 20),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: value.map((selectedHashtag) {
                                    //Get the index of this HashTag in the original list of images
                                    // final indexOfTappedHashtag = availableHashtags.indexWhere(
                                    //   (item) => item.first == hashtagTitle
                                    // );

                                    //Using this index, get the notifier associated with it in the list of notifiers.
                                    // final notifier = listOfValueNotifiers.elementAt(indexOfTappedHashtag);

                                    return AmptiveCustomContainer(
                                      margin: const EdgeInsets.only(right: 15),
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 7, 15, 7),
                                      alignment: Alignment.center,
                                      radius: 10,
                                      color: AmptiveColors.whiteColor
                                          .withOpacity(0.1),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            selectedHashtag.obj.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                              color:
                                              AmptiveColors.grey5Color,
                                            ),
                                          ),
                                          const Gap(5),
                                          GestureDetector(
                                              onTap: () {
                                                //Disable this notifier
                                                selectedHashtag.notifier.value =
                                                false;
                                                //Remove this title from list
                                                service.removeSelectedHashtags(
                                                    selectedHashtag);
                                              },
                                              child: const Icon(Icons.close,
                                                  size: 20))
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      //Column of hashtags
                      AmptiveRebuilderWidget(
                          notifier: searchQueryNotifier,
                          builder: (_, searchString, __) {
                            List<ObjectWithNotifier<Hashtag>>
                            filteredHashtagTitles;

                            if (searchString.isEmpty ||
                                controller.text.isEmpty) {
                              filteredHashtagTitles = availableHashtags;
                            } else {
                              filteredHashtagTitles = availableHashtags
                                  .where((hashtag) => hashtag.obj.name
                                  .toLowerCase()
                                  .contains(searchString.toLowerCase()))
                                  .toList();

                              if (filteredHashtagTitles.isEmpty) {
                                filteredHashtagTitles.add(
                                    ObjectWithNotifier<Hashtag>(
                                        obj: Hashtag(name: searchString)));
                              }
                            }

                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15),
                              child: AmptiveListOfHashtagsWidget(
                                hashtags: filteredHashtagTitles,
                              ),
                            );
                          })
                    ]),
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: 80.h,
                width: AmptiveHelperFunctions.getScreenWidth(context),
                child: ClipRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: const SizedBox(height: 100)),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: AmptiveCustomContainer(
                height: 50.h,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: AmptiveHelperFunctions.getScreenWidth(context),
                child: AmptiveRebuilderWidget(
                    notifier: service.selectedHashtagLength,
                    builder: (_, value, __) {
                      return AmptiveElevatedButtonWidget(
                        margin: EdgeInsets.zero,
                        onPressed: value > 0
                            ? () async {
                          Navigator.pop(
                              context, service.selectedHashtags.value);
                        }
                            : null,
                        buttonTitle: AmptiveOtherStrings.CONTINUE,
                        bgColor: AmptiveColors.whiteColor,
                        fgColor: AmptiveColors.black,
                      );
                    }),
              ),
            )
          ],
        );
      });
}

class AmptiveListOfHashtagsWidget extends StatelessWidget {
  final List<ObjectWithNotifier<Hashtag>> hashtags;
  final CreateShowService service = GetIt.I<CreateShowService>();

  AmptiveListOfHashtagsWidget({
    super.key,
    required this.hashtags,
  });

  @override
  Widget build(context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              hashtags.isEmpty
                  ? AmptiveOtherStrings.NO_TRENDING_HASHTAGS
                  : AmptiveOtherStrings.TRENDING_HASHTAGS,
              style: Theme.of(context).textTheme.bodyMedium),
          Gap(3.h),
          hashtags.isEmpty
              ? Text(
            maxLines: 2,
            AmptiveOtherStrings.SEARCH_UR_HASHTAGS,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AmptiveColors.hexC2C2C2),
          )
              : const SizedBox.shrink(),
          ...hashtags.map((hashtagData) {
            ;

            return AmptiveAddHashtagWidget(
              hashtagDetail: hashtagData,
              onTap: (hashtagTitle) {
                if (hashtagTitle.notifier.value) {
                  service.removeSelectedHashtags(hashtagTitle);
                } else {
                  service.addSelectedHashtags(hashtagTitle);
                }
              },
            );
          }),
        ]);
  }
}

class AmptiveAddHashtagWidget extends StatelessWidget {
  final void Function(ObjectWithNotifier<Hashtag>) onTap;
  final ObjectWithNotifier<Hashtag> hashtagDetail;

  const AmptiveAddHashtagWidget({
    super.key,
    required this.onTap,
    required this.hashtagDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () {
          onTap(hashtagDetail);
        },
        child: Row(
          children: [
            AmptiveCustomContainer(
              height: 50,
              width: 50,
              color: AmptiveColors.whiteColor,
              radius: 30,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('#',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: AmptiveColors.brandBlack)),
              ),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('#${hashtagDetail.obj.name}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: AmptiveFontSizes.size15)),
                  Text(
                    "Hashtag",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AmptiveColors.hexC2C2C2),
                  ),
                ],
              ),
            ),
            AmptiveRebuilderWidget(
                notifier: hashtagDetail.notifier,
                builder: (_, value, __) {
                  return AmptiveCustomContainer(
                      duration: 200,
                      color: value
                          ? AmptiveColors.whiteColor
                          : AmptiveColors.transparentColor,
                      border: Border.all(color: AmptiveColors.whiteColor),
                      boxShape: BoxShape.circle,
                      height: 24,
                      width: 24,
                      child: Icon(
                        Icons.check,
                        color: AmptiveColors.brandBlack,
                        size: 20,
                      ));
                })
          ],
        ),
      ),
    );
  }
}