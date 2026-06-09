import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/features/go_live/cubits/end_live_program_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/rich_text.dart';
import 'package:amptive/src/shared/spotlight_beam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/api_response_and_app_state.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../shared/animated_switcher.dart';

Future<void> hostEndProgramModal({
  required BuildContext context,
  required int noOfListeners,
  required int noOfGifts,
  required EndLiveProgramCubit endLiveProgramCubit,
  required String programId,
  required String programCoverUrl
}) async {
  return await showModalBottomSheet(
      backgroundColor: ATColors.hex202020,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      constraints: BoxConstraints(
        minHeight: context.screenHeight,
        minWidth: context.screenWidth,
      ),
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
            programId: programId,
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
    required this.programId,
  });

  final int noOfListeners, noOfGifts;
  final String programCoverUrl, programId;
  
  @override
  Widget build(BuildContext context) {
    final double screenHeight = context.screenHeight;
    return Container(
      height: screenHeight,
      width: context.screenWidth,
      color: ATColors.black,
      child: BlocConsumer<EndLiveProgramCubit, ATAppState<LoadingStage>>(
        listener: (_, ATAppState<LoadingStage> state) {
          if(state is FailureState<LoadingStage>) {
            showAppNotification2(
              context: context,
              text: state.message,
            );
          }
          else if(state is SuccessState<LoadingStage>) {
            Navigator.pop(context);
          }
        },
        builder: (_, ATAppState<LoadingStage> state) {
          final bool isLoading = state is LoadingState<LoadingStage>;
          final LoadingStage? currentStage = context
            .read<EndLiveProgramCubit>().currentStage;

          final bool isIdle = 
            currentStage == null;
          final bool inStage1 = 
            currentStage == LoadingStage.showListeners;
          final bool inStage2 = 
            currentStage == LoadingStage.showGifts;
          final bool inFinalStage = 
            currentStage == LoadingStage.finished;
          final bool canShowGifts = inStage2 || inFinalStage;
          final bool canShowListeners = inStage1
            || inStage2 || inFinalStage;

          final double positionOfImage = screenHeight * 0.27,
          positionOfSpotlight = positionOfImage + 150;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: screenHeight * 0.15,
                right: 15, left: 15,
                child: ATFadingSwitcher(
                  child: isIdle ? Text(
                    ATStrings.endLiveShowPrompt,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium
                      ?.copyWith(fontSize: 23)
                  ) : const SizedBox.shrink(),
                ),
              ),
              
              AnimatedPositioned(
                top: canShowGifts ? screenHeight * 0.16 : screenHeight * 0.19,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate,
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

              Positioned(
                top: screenHeight * 0.19,
                child: ATFadingSwitcher(
                  child: canShowGifts ? ATRichText(
                    items: <String, TextStyle>{
                      'You received ': context.textTheme.bodySmall!
                        .copyWith(color: ATColors.hexC2C2C2),
                      '200 gifts': context.textTheme.bodyMedium!
                        .copyWith(fontSize: ATSizes.size14),
                    },
                  ) : const SizedBox.shrink(),
                ),
              ),

              Positioned(
                top: positionOfSpotlight,
                child: SpotlightBeam(
                  width: context.screenWidth * 2,
                  halfWidthOfSpot: 75,
                  height: screenHeight * 0.7,
                  //duration: 200,
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

              Positioned(
                top: positionOfImage,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: isIdle ? 150 : 200,
                  width: isIdle ? 150 : 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ATImgLoader(
                      imgPath: programCoverUrl,
                      boxFit: BoxFit.cover,
                      height: isIdle ? 150 : 200,
                      width: isIdle ? 150 : 200,
                    ),
                  ),
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
                        context.read<EndLiveProgramCubit>().endLiveProgram(
                          programId,
                        );
                      },
                      bgColor: ATColors.hexECO404,
                      fgColor: ATColors.white,
                      btnTitle: ATStrings.endNow,
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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
