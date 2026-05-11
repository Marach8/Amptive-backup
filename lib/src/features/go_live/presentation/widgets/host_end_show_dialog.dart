import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/go_live/cubits/end_live_program_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_bloc.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/rich_text.dart';
import 'package:amptive/src/shared/spotlight_beam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/host_end_show_bloc.dart';
import '../../../../config/api_response_and_app_state.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../shared/animated_switcher.dart';

Future<void> hostEndProgramModal({
  required BuildContext context,
  required int noOfListeners,
  required int noOfGifts,
  required EndLiveProgramCubit endLiveProgramCubit,
  required String programCoverUrl
}) async {
  return await showModalBottomSheet(
      backgroundColor: ATColors.hex202020,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: ATColors.black.withValues(alpha: 0.6),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )),
      builder: (BuildContext context) {
        return BlocProvider<EndLiveProgramCubit>.value(
          value: endLiveProgramCubit,
          child: _SubWidget(
            noOfListeners: noOfListeners,
            programCoverUrl: programCoverUrl,
            noOfGifts: noOfGifts,
          ),
        );
      }
    );
}



class _SubWidget extends StatelessWidget {
  const _SubWidget({
    required this.noOfListeners,
    required this.noOfGifts,
    required this.programCoverUrl,
  });

  final int noOfListeners, noOfGifts;
  final String programCoverUrl;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight,
      //width: context.screenWidth,
      color: ATColors.black,
      child: BlocConsumer<EndLiveProgramCubit, ATAppState<LoadingStage>>(
        listener: (_, ATAppState<LoadingStage> state) {

        },
        builder: (_, ATAppState<LoadingStage> state) {
          final bool isLoading = state is LoadingState<LoadingStage>;
          final LoadingStage? currentStage = context
            .read<EndLiveProgramCubit>().currentStage;

          final bool isInitialState = 
            currentStage == LoadingStage.initial;
          final bool inStage1 = 
            currentStage == LoadingStage.showListeners;
          final bool inStage2 = 
            currentStage == LoadingStage.showGifts;
          final bool canShowListeners = inStage1 || inStage2;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned.fill(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: context.screenHeight * 0.15),
                    ATFadingSwitcher(
                      child: isInitialState ? Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          ATStrings.endLiveShowPrompt,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium
                            ?.copyWith(fontSize: 23)
                        ),
                      ) : const SizedBox.shrink(),
                    ),
          
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 500),
                      offset: inStage2 ? const Offset(0, -1) : Offset.zero,
                      child: ATFadingSwitcher(
                        child: canShowListeners ? ATRichText(
                          items: <String, TextStyle>{
                            'You had a total of ': context.textTheme.bodySmall!
                              .copyWith(color: ATColors.hexC2C2C2),
                            '144k listeners': context.textTheme.bodyMedium!
                              .copyWith(fontSize: ATSizes.size14),
                          },
                        ) : const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ATFadingSwitcher(
                      child: inStage2 ? ATRichText(
                        items: <String, TextStyle>{
                          'You received ': context.textTheme.bodySmall!
                            .copyWith(color: ATColors.hexC2C2C2),
                          '200 gifts': context.textTheme.bodyMedium!
                            .copyWith(fontSize: ATSizes.size14),
                        },
                      ) : const SizedBox.shrink(),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: ATImgLoader(
                          imgPath: programCoverUrl,
                          height: isInitialState ? 150 : 200,
                          width: isInitialState ? 150 : 200,
                        ),
                      ),
                    ),
          
                    Flexible(
                      child: SpotlightBeam(
                        width: context.screenWidth * 4,
                        halfWidthOfSpot: isInitialState ? 75 : 100,
                        duration: 200,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            ATColors.hex0D0D0D,
                            ATColors.hex090909
                          ],
                        )
                      ),
                    ),
                  ],
                ),
              ),
          
              isLoading ? Positioned(
                bottom: 60,
                child: ATLoadingIndicator(
                  color: ATColors.white,
                ),
              ) : Positioned(
                bottom: 0, left: 15, right: 15,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ATPlainElevatedBtn(
                      onPressed: () {
                        // context
                        //     .read<LivestreamBloc>()
                        //     .add(const EndStreamEvent());
                        // context
                        //     .read<AmptiveEndShowBloc>()
                            // .add(Proceed2EndShowEvent());
                      },
                      bgColor: ATColors.hexECO404,
                      fgColor: ATColors.white,
                      btnTitle: ATStrings.endNow,
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(ATStrings.cancel,
                          style: context.textTheme.bodyMedium
                            ?.copyWith(fontSize: 17)),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
