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
import '../../views/widgets/common_widgets/search_filter_widget.dart';
import '../constants/strings/other_strings.dart';

Future<Set<HostWithNotifier>?> showAddCoHostDialog(BuildContext context) async {
  CreateShowService service = GetIt.I<CreateShowService>();

  final List<HostWithNotifier> coHostsData = getHostList();

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
                              // shouldDispose: true,
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
                        notifier: service.coHostSelectionStarted,
                        // shouldDispose: true,
                        builder: (_, selectionStarted, __) {                          
                          return AmptiveAnimatedCrossFadeWidget(
                            condition: !selectionStarted,
                            firstChild: const SizedBox.shrink(),
                            secondChild: AmptiveCustomContainer(
                              height: 43, alignment: Alignment.center,
                              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: AmptiveRebuilderWidget(
                                  notifier: service.selectedCoHosts,
                                  builder: (_, selectedCoHosts, __) {
                                    return Row(
                                      children: selectedCoHosts.map((selectedCoHost) {
                                        final showCoHost = selectedCoHost.host.profilePicture != null;
                                        
                                        if(!showCoHost){
                                          final index = selectedCoHosts.toList().indexOf(selectedCoHost);
                                    
                                          return AmptiveCustomContainer(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(right: 15),
                                            border: Border.all(color: AmptiveColors.whiteColor.withOpacity(0.4)),
                                            height: 43, width: 43, radius: 30,
                                            child: Text(
                                              (index + 1).toString(),
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontSize: AmptiveFontSizes.size12
                                              ),
                                            ),
                                          );
                                        }
                                    
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 15),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              AmptiveCustomContainer(
                                                clipBehavior: Clip.hardEdge,
                                                height: 43, width: 43, radius: 30,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: AmptiveImageLoaderWidget(
                                                    imagePath: selectedCoHost.host.profilePicture ?? ''
                                                  )
                                                ),
                                              ),
                                              Positioned(
                                                top: 0, right: -4, 
                                                child: AmptiveCustomContainer(
                                                  onTap: () {
                                                    service.removeSelectedCoHost(selectedCoHost);
                                                  },
                                                  color: AmptiveColors.textRedColor,
                                                  height: 17, width: 17,
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
                                    );
                                  }
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
                            List<HostWithNotifier> filteredCoHosts;

                            if (searchString.isEmpty || controller.text.isEmpty) {
                              filteredCoHosts = coHostsData;
                            } 
                            else {
                              filteredCoHosts = coHostsData.where((coHost) {
                                return coHost.host.name!
                                        .toLowerCase()
                                        .contains(searchString.toLowerCase()) ||
                                    coHost.host.username!
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
                  notifier: service.coHostSelectionStarted,
                  // shouldDispose: true,
                  builder: (_, value, __) {
                    return AmptiveElevatedButtonWidget(
                      margin: EdgeInsets.zero,
                      onPressed: value
                        ? (){
                        final selectedCoHosts = service.selectedCoHosts.value.where(
                          (coHost) => coHost.host.profilePicture != null
                        );
                        context.pop(selectedCoHosts.toSet());
                        } : null,
                      buttonTitle: AmptiveOtherStrings.CONTINUE,
                      bgColor: AmptiveColors.whiteColor,
                      fgColor: AmptiveColors.black,
                    );
                  }
                ),
              ),
            )
          ],
        );
      }
    );
}



class AmptiveListOfCoHostsWidget extends StatelessWidget {
  final List<HostWithNotifier> availableCoHosts;
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
          Text(
            AmptiveOtherStrings.NO_SUGGESTIONS,
            style: Theme.of(context).textTheme.bodyMedium
          ),
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
      children: availableCoHosts.map((coHost) {
        return AmptiveCoHostWidget(
          coHostDetail: coHost,
          onTap: (host, isSelected) {
            if (isSelected) {              
              service.removeSelectedCoHost(host);
            } else {
              service.addSelectedCoHost(host);
            }
          },
        );
      }
    ).toList());
  }
}



class AmptiveCoHostWidget extends StatelessWidget {
  final void Function(HostWithNotifier, bool) onTap;
  final HostWithNotifier coHostDetail;

  const AmptiveCoHostWidget({
    super.key,
    required this.onTap,
    required this.coHostDetail,
  });

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () => onTap(coHostDetail, coHostDetail.notifier.value),
        child: Row(
          children: [
            AmptiveCustomContainer(
              clipBehavior: Clip.hardEdge,
              height: 50, width: 50, radius: 30,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: AmptiveImageLoaderWidget(
                      imagePath: coHostDetail.host.profilePicture!)),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AmptiveRebuilderWidget(
                  //   notifier: searchQueryNotifier,
                  //   builder: (_, ) {
                  //     return AmptiveSearchFilterWidget(
                  //       title: coHostDetail.host.name ?? '',
                  //       searchQuery:
                  //       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //         fontSize: AmptiveFontSizes.size15
                  //       )
                  //     );
                  //   }
                  // ),
                  Text(
                    coHostDetail.host.name ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: AmptiveFontSizes.size15
                    )
                  ),
                  Text(
                    coHostDetail.host.username ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AmptiveColors.subtitleColor
                    ),
                  ),
                ],
              ),
            ),
            AmptiveRebuilderWidget(
              notifier: coHostDetail.notifier,
              builder: (_, value, __) {
                return AmptiveCustomContainer(
                  duration: 200,
                  color: value ? AmptiveColors.whiteColor : AmptiveColors.transparentColor,
                  border: Border.all(color: AmptiveColors.whiteColor),
                  boxShape: BoxShape.circle,
                  height: 24, width: 24,
                  child: Icon(
                    Icons.check, size: 20,
                    color: AmptiveColors.brandBlack,
                  )
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
