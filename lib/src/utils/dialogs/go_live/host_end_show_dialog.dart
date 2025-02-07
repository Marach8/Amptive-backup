import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/two_texts_rich_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/main_app/go_live_bloc/host_view/host_end_show_bloc.dart';
import '../../../bloc/main_app/nav_bar_bloc.dart';
import '../../constants/strings/other_strings.dart';

Future<void> showHostEndShowDialog({
  required BuildContext context,
}) async {
  return await showModalBottomSheet(
    backgroundColor: AmptiveColors.hex202020,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: AmptiveColors.black.withOpacity(0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15),
    )),
    builder: (context) {
      return AmptiveCustomContainer(
        height: AmptiveHelperFunctions.getScreenHeight(context),
        width: AmptiveHelperFunctions.getScreenWidth(context),
        color: AmptiveColors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [            
            BlocConsumer<AmptiveEndShowBloc, EndShowState>(
              listener: (_, state){
                if(state is ShowBlankScreenState){
                  Future.delayed(
                    const Duration(seconds: 2),
                    (){
                      if(context.mounted){
                        context.read<AmptiveNavBarBloc>().goToPage(0);                        
                        context.pop();
                        showNormalNotification(
                          child: const Icon(Icons.check_circle),
                          text: 'Your live show has ended',
                          bgColor: AmptiveColors.notifBg
                        );
                      }
                    }
                  );
                }

                else if(state is EndShowIsLoadingState){
                  Future.delayed(
                    const Duration(seconds: 5),
                    (){
                      if(context.mounted){
                        context.read<AmptiveEndShowBloc>().add(
                          ShowNoOfListenersEvent()
                        );
                      }
                    }
                  );
                }

                else if(state is ShowNoOfListenersState){
                  Future.delayed(
                    const Duration(seconds: 5),
                    (){
                      if(context.mounted){
                        context.read<AmptiveEndShowBloc>().add(
                          ShowNoOfGiftsEvent()
                        );
                      }
                    }
                  );
                }

                else if(state is ShowNoOfGiftsState){
                  Future.delayed(
                    const Duration(seconds: 5),
                    (){
                      if(context.mounted){
                        context.read<AmptiveEndShowBloc>().add(
                          ShowBlankScreenEvent()
                        );
                      }
                    }
                  );
                }
              },
              builder: (_, state) {
                final initialState = state is ConfirmEndShowState;
                final finalState = state is ShowBlankScreenState;

                if(finalState){
                  return const SizedBox.shrink();
                }

                return AnimatedPositioned(
                  duration: const Duration(seconds: 1),
                  top: initialState ? 200 : 220,
                  child: AmptiveCustomContainer(
                    clipBehavior: Clip.hardEdge,
                    radius: 5, height: initialState ? 150 : 200, 
                    width: initialState ? 150 : 200,
                    child: const AmptiveImageLoaderWidget(                  
                      imagePath: AmptiveImageStrings.weCanDoHardThingsBgImage
                    ),
                  ),
                );
              }
            ),

            BlocBuilder<AmptiveEndShowBloc, EndShowState>(
              builder: (_, state) {
                final showNoOfListeners = state is ShowNoOfListenersState; 
                final showNoOfGifters = state is ShowNoOfGiftsState;
                final initialState = state is ConfirmEndShowState;
                final finalState = state is ShowBlankScreenState;

                if(finalState){
                  return const SizedBox.shrink();
                }

                return AnimatedPositioned(
                  duration: const Duration(seconds: 1), left: 15, right: 15,
                  top: (showNoOfListeners || showNoOfGifters) ? 140 :100, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(initialState)Text(
                        AmptiveOtherStrings.END_LIVE_SHOW,
                        maxLines: 2, textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AmptiveFontSizes.size23
                        )
                      ),
                      if(showNoOfListeners || showNoOfGifters)AmptiveTwoTextRichTextWidget(
                        text1: 'You had a total of ',
                        text2: '144k listeners',
                        style1: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AmptiveColors.hexC2C2C2
                        ),
                        style2: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AmptiveFontSizes.size14
                        ),
                      ),
                      const Gap(10),
                      if(showNoOfGifters)AmptiveTwoTextRichTextWidget(
                        text1: 'You received ',
                        text2: '200 gifts',
                        style1: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AmptiveColors.hexC2C2C2
                        ),
                        style2: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AmptiveFontSizes.size14
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),

            BlocBuilder<AmptiveEndShowBloc, EndShowState>(
              builder: (_, state) {
                final isLoading = state is EndShowIsLoadingState 
                  || state is ShowNoOfListenersState 
                  || state is ShowNoOfGiftsState;
                final finalState = state is ShowBlankScreenState;

                if(isLoading){
                  return Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AmptiveLoadingIndicatorWidget(
                        color: AmptiveColors.whiteColor,
                      ),
                    ),
                  );
                }
                else if(finalState){
                  return const SizedBox.shrink();
                }

                return Positioned(
                  bottom: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AmptiveCustomContainer(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        width: AmptiveHelperFunctions.getScreenWidth(context),
                        height: 50,
                        child: AmptiveElevatedButtonWidget(
                          onPressed: () => context.read<AmptiveEndShowBloc>().add(
                            Proceed2EndShowEvent()
                          ),
                          bgColor: AmptiveColors.notifRed,
                          fgColor: AmptiveColors.whiteColor,
                          buttonTitle: AmptiveOtherStrings.END_NOW,
                        ),
                      ),
                      const Gap(15),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          AmptiveOtherStrings.CANCEL,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AmptiveFontSizes.size17
                          )
                        ),
                      ),
                      const Gap(15),
                    ],
                  ),
                );
              }
            )
          ],
        ),
      );
    }
  );
}
