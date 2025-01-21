import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../bloc/main_app/go_live_bloc/host_view/available_cohosts_bloc.dart';
import '../../../models/host.dart';
import '../../../services/create_show/create_show_service.dart';
import '../../../views/widgets/common_widgets/loading_indicator.dart';
import '../../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../../constants/strings/other_strings.dart';
import '../add_co_host_dialog.dart';

Future<bool?> showGoLiveHostAddCoHostDialog({
  required BuildContext context,
}) async {
final focusNode = FocusNode();
final controller = TextEditingController();

final showSuffixIconNotifier = ValueNotifier(false);
  focusNode.addListener(
    () => focusNode.hasFocus
      ? showSuffixIconNotifier.value = true
      : showSuffixIconNotifier.value = false
  );

  return await showModalBottomSheet<bool>(
      backgroundColor: AmptiveColors.brandBlack,
      constraints: BoxConstraints.expand(
        height: AmptiveHelperFunctions.getScreenHeight(context)
      ),
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
                  left: 15, right: 15, top: 20.h
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => context.pop(false),
                        child: Platform.isAndroid
                            ? Icon(
                                Icons.keyboard_arrow_down,
                                color: AmptiveColors.whiteColor.withOpacity(0.6),
                              )
                            : AmptiveCustomContainer(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                radius: 5, height: 4, width: 30,
                                color: AmptiveColors.whiteColor.withOpacity(0.6),
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
                          BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
                            builder: (_, listOfCoHosts) {
                              final number = listOfCoHosts.where(
                                (coHost) => (coHost.obj.profilePicture ?? '').isNotEmpty
                              ).length;

                              return Text(
                                '$number ${AmptiveOtherStrings.SELECTED}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AmptiveColors.subtitleColor
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                      const Gap(20),

                      Text(
                        maxLines: 3,
                        AmptiveOtherStrings.ADD_COHOST_DESC,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AmptiveColors.subtitleColor
                        ),
                      ),
                      const Gap(20),

                      // search SEARCH
                      AmptiveTextFormFieldWidget(
                        controller: controller,
                        focusNode: focusNode,
                        disableBlueBorder: true,
                        onChanged: (text) => AmptiveHelperFunctions.callDebouncer(
                          200,
                          () => context.read<AmptiveGoLiveAvailableCoHostsBloc>().add(
                            SearchCohostEvent(searchKey: text)
                          ),
                        ),
                        hintText: AmptiveOtherStrings.SEARCH_4_COHOSTS,
                        prefixConstraints: const BoxConstraints(maxWidth: 50),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Iconsax.search_normal_14),
                        ),
                        suffixIcon: AmptiveRebuilderWidget(
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
                          }
                        ),
                      ),


                      BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
                        builder: (_, listOfCohosts) {
                          final showSelectedCohosts = listOfCohosts.any(
                            (cohost) => (cohost.obj.profilePicture ?? '').isNotEmpty
                          );

                          return AmptiveAnimatedCrossFadeWidget(
                            condition: showSelectedCohosts,
                            secondChild: const SizedBox.shrink(),
                            firstChild: AmptiveCustomContainer(
                              height: 43, alignment: Alignment.center,
                              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: listOfCohosts.map(
                                    (cohost) {
                                      final showCoHost = (cohost.obj.profilePicture ?? '').isNotEmpty;
                                      final index = listOfCohosts.indexOf(cohost);
                                      
                                      if(!showCoHost){
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
                                                  imagePath: cohost.obj.profilePicture ?? ''
                                                )
                                              ),
                                            ),
                                            Positioned(
                                              top: 0, right: -4, 
                                              child: AmptiveCustomContainer(
                                                onTap: () => context.read<AmptiveGoLiveSelectCoHostBloc>()
                                                  .hostRemoveCohost(cohost),
                                                color: AmptiveColors.textRedColor,
                                                height: 17, width: 17,
                                                boxShape: BoxShape.circle,
                                                child: const FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Icon(Icons.close)
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                      }
                                    ).toList(),
                                  )
                                )
                            ),
                          );
                        },
                      ),
                      const Gap(20),

                      //Column of cohosts
                      BlocBuilder<AmptiveGoLiveAvailableCoHostsBloc, AmptiveCohostsState>(
                        builder: (_, cohostState) {
                          if(cohostState is CohostsLoadingState){
                            return const AmptiveLoadingIndicatorWidget();
                          }
                          
                          return AmptiveListOfCoHostsWidget(
                            availableCoHosts: cohostState.cohosts ?? []
                          );
                        }
                      ),
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
                    child: const SizedBox(height: 100)
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: AmptiveCustomContainer(
                height: 50.h,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: AmptiveHelperFunctions.getScreenWidth(context),
                child: BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
                  builder: (_, listOfCohosts) {
                    final shouldActivateBtn = listOfCohosts.any(
                      (cohost) => (cohost.obj.profilePicture ?? '').isNotEmpty
                    );
                    return AmptiveElevatedButtonWidget(
                      margin: EdgeInsets.zero,
                      onPressed: shouldActivateBtn ? () => context.pop(true) : null,
                      buttonTitle: AmptiveOtherStrings.SEND_INVITE,
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
      children: availableCoHosts.map(
        (coHost) {
          //final index = availableCoHosts.indexOf(coHost);
          return AmptiveCoHostWidget(
            coHostDetail: coHost,
            onTap: (host, isSelected) {
              if (isSelected) {         
                context.read<AmptiveGoLiveSelectCoHostBloc>().hostRemoveCohost(coHost);
              } else {
                context.read<AmptiveGoLiveSelectCoHostBloc>().hostAddCohost(coHost);
              }
            },
          );
      }
    ).toList());
  }
}
