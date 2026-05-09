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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/host_end_show_bloc.dart';
import '../../../../config/api_response_and_app_state.dart';
import '../../../../config/utils/other_strings.dart';

Future<void> showHostEndShowDialog({
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


enum _PrivateState {initial, showListeners, showGifts}
class _SubWidget extends StatefulWidget {
  const _SubWidget({
    required this.noOfListeners,
    required this.noOfGifts,
    required this.programCoverUrl,
  });

  final int noOfListeners, noOfGifts;
  final String programCoverUrl;
  
  @override
  State<_SubWidget> createState() => _SubWidgetState();
}

class _SubWidgetState extends State<_SubWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<EndLiveProgramCubit, ATAppState<bool>>(
      listener: (_, ATAppState<bool> state) {
        
      },
      child: Container(
        height: context.screenHeight,
        width: context.screenWidth,
        color: ATColors.black,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            BlocConsumer<AmptiveEndShowBloc, EndShowState>(
                listener: (_, EndShowState state) {
              // if (state is ShowBlankScreenState) {
              //   Future.delayed(const Duration(seconds: 2), () {
              //     if (context.mounted) {
              //       context.read<ATNavBarBloc>().goToPage(0, context);
              //       context.pop();
              //       showAppNotification(
              //           context: context,
              //           icon: const Icon(Icons.check_circle),
              //           text: 'Your live show has ended',
              //           bgColor: ATColors.notifBg);
              //     }
              //   });
              // } else if (state is EndShowIsLoadingState) {
              //   Future.delayed(const Duration(seconds: 5), () {
              //     if (context.mounted) {
              //       context
              //           .read<AmptiveEndShowBloc>()
              //           .add(ShowNoOfListenersEvent());
              //     }
              //   });
              // } else if (state is ShowNoOfListenersState) {
              //   Future.delayed(const Duration(seconds: 5), () {
              //     if (context.mounted) {
              //       context
              //           .read<AmptiveEndShowBloc>()
              //           .add(ShowNoOfGiftsEvent());
              //     }
              //   });
              // } else if (state is ShowNoOfGiftsState) {
              //   Future.delayed(const Duration(seconds: 5), () {
              //     if (context.mounted) {
              //       context
              //           .read<AmptiveEndShowBloc>()
              //           .add(ShowBlankScreenEvent());
              //     }
              //   });
              // }
            },
            builder: (_, EndShowState state) {
              final bool initialState = state is ConfirmEndShowState;
              final bool finalState = state is ShowBlankScreenState;
      
              if (finalState) {
                return const SizedBox.shrink();
              }
      
              return AnimatedPositioned(
                duration: const Duration(seconds: 1),
                top: initialState ? 200 : 220,
                child: ATContainer(
                  clipBehavior: Clip.hardEdge,
                  radius: 5,
                  height: initialState ? 150 : 200,
                  width: initialState ? 150 : 200,
                  child: const ATImgLoader(
                      imgPath: ATImgStrings.weCanDoHardThingsBgImage),
                ),
              );
            }),
      
            BlocBuilder<AmptiveEndShowBloc, EndShowState>(
                builder: (_, EndShowState state) {
              final bool showNoOfListeners = state is ShowNoOfListenersState;
              final bool showNoOfGifters = state is ShowNoOfGiftsState;
              final bool initialState = state is ConfirmEndShowState;
              final bool finalState = state is ShowBlankScreenState;
      
              if (finalState) {
                return const SizedBox.shrink();
              }
      
              return AnimatedPositioned(
                duration: const Duration(seconds: 1),
                left: 15,
                right: 15,
                top: (showNoOfListeners || showNoOfGifters) ? 140 : 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (initialState)
                      Text(ATStrings.endLiveShowPrompt,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: ATSizes.size23)),
                    if (showNoOfListeners || showNoOfGifters)
                      ATRichText(
                        items: <String, TextStyle>{
                          'You had a total of ': Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: ATColors.hexC2C2C2),
                          '144k listeners': Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: ATSizes.size14),
                        },
                      ),
                    const SizedBox(height: 10),
                    if (showNoOfGifters)
                      ATRichText(
                        items: <String, TextStyle>{
                          'You received ': Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: ATColors.hexC2C2C2),
                          '200 gifts': Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: ATSizes.size14),
                        },
                      ),
                  ],
                ),
              );
            }),
      
            BlocBuilder<AmptiveEndShowBloc, EndShowState>(
                builder: (_, EndShowState state) {
              final bool isLoading = state is EndShowIsLoadingState ||
                  state is ShowNoOfListenersState ||
                  state is ShowNoOfGiftsState;
              final bool finalState = state is ShowBlankScreenState;
      
              if (isLoading) {
                return Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ATLoadingIndicator(
                      color: ATColors.white,
                    ),
                  ),
                );
              } else if (finalState) {
                return const SizedBox.shrink();
              }
      
              return Positioned(
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ATContainer(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      width: ATHelperFuncs.getScreenWidth(context),
                      height: 50,
                      child: AmptiveElevatedButtonWidget(
                        onPressed: () {
                          // context
                          //     .read<LivestreamBloc>()
                          //     .add(const EndStreamEvent());
                          context
                              .read<AmptiveEndShowBloc>()
                              .add(Proceed2EndShowEvent());
                        },
                        bgColor: ATColors.hexECO404,
                        fgColor: ATColors.white,
                        buttonTitle: ATStrings.endNow,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(ATStrings.cancel,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: ATSizes.size17)),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
