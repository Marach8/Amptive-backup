import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
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

Future<Set<ObjectWithNotifier<Host>>?> showAddCoHostDialog(BuildContext context) async {
  CreateShowService service = GetIt.I<CreateShowService>();

  final List<ObjectWithNotifier<Host>> coHostsData = service.coHostsListData;

  final focusNode = FocusNode();
  final controller = TextEditingController();
  final showSuffixIconNotifier = ValueNotifier(false);
  focusNode.addListener(() => focusNode.hasFocus
      ? showSuffixIconNotifier.value = true
      : showSuffixIconNotifier.value = false);

  final searchQueryNotifier = ValueNotifier('');

  return await showModalBottomSheet(
      backgroundColor: AmptiveColors.brandBlackColor,
      constraints: BoxConstraints.expand(
          height: AmptiveHelperFunctions.getScreenHeight(context)),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.viewInsetsOf(context).bottom,
                    left: 15,
                    right: 15,
                    top: 20.h),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AmptiveOtherStrings.ADD_CO_HOST,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Gap(60.w),
                          AmptiveRebuilderWidget(
                              notifier: service.selectedCoHostLength,
                              builder: (_, number, __) {
                                return Text(
                                  '$number ${AmptiveOtherStrings.SELECTED}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AmptiveColors.subtitleColor),
                                );
                              }),
                        ],
                      ),
                      const Gap(20),

                      Text(
                        maxLines: 3,
                        AmptiveOtherStrings.ADD_COHOST_DESC,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AmptiveColors.subtitleColor),
                      ),
                      const Gap(20),

                      // search SEARCH
                      AmptiveTextFormFieldWidget(
                        controller: controller,
                        focusNode: focusNode,
                        disableBlueBorder: true,
                        onChanged: (text) {
                          searchQueryNotifier.value = text;
                        },
                        hintText: AmptiveOtherStrings.SEARCH_4_COHOSTS,
                        prefixConstraints: const BoxConstraints(maxWidth: 50),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Iconsax.search_normal_14),
                        ),
                        suffixIcon: AmptiveRebuilderWidget(
                            shouldDispose: true,
                            notifier: showSuffixIconNotifier,
                            builder: (_, shouldShow, __) {
                              return AmptiveAnimatedCrossFadeWidget(
                                condition: shouldShow,
                                secondChild: const SizedBox.shrink(),
                                firstChild: GestureDetector(
                                  onTap: () => controller.clear(),
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.close, size: 20),
                                  ),
                                ),
                              );
                            }),
                      ),

                      AmptiveRebuilderWidget(
                        notifier: service.selectedCoHostLength,
                        // shouldDispose: true,
                        builder: (_, val, __) {
                          var value = service.selectedCoHosts.value;
                          return AmptiveAnimatedCrossFadeWidget(
                            condition: value.isEmpty,
                            firstChild: const SizedBox.shrink(),
                            secondChild: AmptiveCustomContainer(
                              height: 43,
                              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: value.map((selCoHost) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          AmptiveCustomContainer(
                                            clipBehavior: Clip.hardEdge,
                                            height: 43,
                                            width: 43,
                                            radius: 30,
                                            child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: AmptiveImageLoaderWidget(
                                                    imagePath: selCoHost
                                                        .obj.profilePicture!)),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: -4,
                                            child: AmptiveCustomContainer(
                                              onTap: () {
                                                //Disable this notifier
                                                selCoHost.notifier.value =
                                                    false;

                                                service.removeSelectedCoHost(
                                                    selCoHost);
                                              },
                                              color: AmptiveColors.textRedColor,
                                              height: 17,
                                              width: 17,
                                              boxShape: BoxShape.circle,
                                              child: const FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Icon(Icons.close)),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const Gap(20),

                      //Column of cohosts
                      AmptiveRebuilderWidget(
                          notifier: searchQueryNotifier,
                          builder: (_, searchString, __) {
                            List<ObjectWithNotifier<Host>> filteredCoHosts;

                            if (searchString.isEmpty ||
                                controller.text.isEmpty) {
                              filteredCoHosts = coHostsData;
                            } else {
                              filteredCoHosts = coHostsData.where((coHost) {
                                return coHost.obj.name!
                                        .toLowerCase()
                                        .contains(searchString.toLowerCase()) ||
                                    coHost.obj.username!
                                        .toLowerCase()
                                        .contains(searchString.toLowerCase());
                              }).toList();
                            }

                            return AmptiveListOfCoHostsWidget(
                              availableCoHosts: filteredCoHosts,
                            );
                          }),
                      Gap(100.h)
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
                    notifier: service.selectedCoHostLength,
                    // shouldDispose: true,
                    builder: (_, value, __) {
                      return AmptiveElevatedButtonWidget(
                        margin: EdgeInsets.zero,
                        onPressed: value > 0
                            ? () async {
                                Navigator.pop(
                                    context, service.selectedCoHosts.value);
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

class AmptiveListOfCoHostsWidget extends StatelessWidget {
  final List<ObjectWithNotifier<Host>> availableCoHosts;
  final CreateShowService service = GetIt.I<CreateShowService>();

  AmptiveListOfCoHostsWidget({
    super.key,
    required this.availableCoHosts,
  });

  @override
  Widget build(context) {
    if (availableCoHosts.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AmptiveOtherStrings.NO_SUGGESTIONS,
              style: Theme.of(context).textTheme.bodyMedium),
          Gap(3.h),
          Text(
            maxLines: 2,
            AmptiveOtherStrings.SEARCH_UR_COHOSTS,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AmptiveColors.subtitleColor),
          ),
        ],
      );
    }

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: availableCoHosts.map((entry) {
          // final notifier = listOfNotifiers.elementAt(entry.key);

          return AmptiveCoHostWidget(
            coHostDetail: entry,
            onTap: (image, isSelected) {
              if (isSelected) {
                // final listOfImages = selectedCoHosts.value;
                // listOfImages.remove(image);
                // selectedCoHosts.value = List.from(listOfImages);
                service.removeSelectedCoHost(image);
              } else {
                // final listOfImages = selectedCoHosts.value;
                // listOfImages.add(image);
                // selectedCoHosts.value = List.from(listOfImages);
                service.addSelectedCoHost(image);
              }
            },
          );
        }).toList());
  }
}

class AmptiveCoHostWidget extends StatelessWidget {
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> coHostDetail;

  // final ValueNotifier<bool> notifier;

  const AmptiveCoHostWidget({
    super.key,
    required this.onTap,
    required this.coHostDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () {
          onTap(coHostDetail, coHostDetail.notifier.value);
          // coHostDetail.notifier.value = !coHostDetail.notifier.value;
        },
        child: Row(
          children: [
            AmptiveCustomContainer(
              clipBehavior: Clip.hardEdge,
              height: 50,
              width: 50,
              radius: 30,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: AmptiveImageLoaderWidget(
                      imagePath: coHostDetail.obj.profilePicture!)),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coHostDetail.obj.name!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: AmptiveFontSizes.size15)),
                  Text(
                    coHostDetail.obj.username!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AmptiveColors.subtitleColor),
                  ),
                ],
              ),
            ),
            AmptiveRebuilderWidget(
                notifier: coHostDetail.notifier,
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
                        color: AmptiveColors.brandBlackColor,
                        size: 20,
                      ));
                })
          ],
        ),
      ),
    );
  }
}
