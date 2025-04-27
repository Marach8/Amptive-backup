import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../bloc/main_app/go_live_bloc/host_view/available_cohosts_bloc.dart';
import '../../../models/host.dart';
import '../../../services/create_show/create_show_service.dart';
import '../../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../constants/strings/other_strings.dart';


Future<void> showListenersDialog({
  required BuildContext context,
  bool? enableKickOut
}) async {

  final focusNode = FocusNode();
  final controller = TextEditingController();

  final showSuffixIconNotifier = ValueNotifier(false);
    focusNode.addListener(
      () => focusNode.hasFocus
        ? showSuffixIconNotifier.value = true
        : showSuffixIconNotifier.value = false
    );

  return await showModalBottomSheet(
    backgroundColor: ATColors.hex202020,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: ATColors.black.withOpacity(0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15),
    )),
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: ATContainer(
            width: ATHelperFuncs.getScreenWidth(context),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Platform.isAndroid
                      ? Icon(
                          Icons.keyboard_arrow_down,
                          color: ATColors.white.withOpacity(0.6),
                        )
                      : ATContainer(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          radius: 5, height: 4, width: 30,
                          color: ATColors.white.withOpacity(0.6),
                          child: const SizedBox.shrink(),
                        ),
                    ),
                  ),
                  const Gap(10),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ATImgLoader(
                          imgPath: ATImgStrings.USER_ICON
                        ),
                        const Gap(5),
                        Text(
                          ATStrings.LISTENERS,
                          style: Theme.of(context).textTheme.bodyLarge
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                    
                  Text(
                    maxLines: 3,
                    ATStrings.TOP_LISTENERS_DESC,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ATColors.hexC2C2C2
                    ),
                  ),
                  const Gap(20),
                  // search SEARCH

                  ATTextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    disableBlueBorder: true,
                    onChanged: (text) => ATHelperFuncs.callDebouncer(
                      200,
                      () => context.read<AmptiveGoLiveAvailableCoHostsBloc>().add(
                        SearchCohostEvent(searchKey: text)
                      ),
                    ),
                    hintText: ATStrings.SEARCH_4_LISTENERS,
                    prefixConstraints: const BoxConstraints(maxWidth: 50),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(Iconsax.search_normal_14),
                    ),
                    suffixIcon: AmptiveRebuilderWidget(
                      notifier: showSuffixIconNotifier,
                      builder: (_, shouldShow, __) {
                        return ATAnimatedCrossFade(
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
                  
                  const Gap(20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ATStrings.TOP_LISTENERS,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                  ),
                  const Gap(10),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: getHostList().length,
                      itemBuilder: (_, listIndex){
                        final listener = getHostList().elementAt(listIndex);
                        return AmptiveListenerWidget(
                          onTap: (_, __){},
                          listener: listener,
                          index: listIndex + 1,
                          enableKickOut: enableKickOut,
                        );
                      },
                    ),
                  ),
              ],
            ),
          )
        ),
      );
    }
  );
}





class AmptiveListenerWidget extends StatelessWidget {
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> listener;
  final bool? enableKickOut;
  final int index;

  const AmptiveListenerWidget({
    super.key,
    required this.onTap,
    required this.listener,
    required this.index,
    this.enableKickOut
  });

  @override
  Widget build(context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () => onTap(listener, listener.notifier.value),
        child: Row(
          children: [
            ATContainer(
              clipBehavior: Clip.hardEdge,
              height: 50, width: 50, radius: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: ATImgLoader(imgPath: listener.obj.profilePicture!)
              ),
            ),
            const Gap(10),
            Expanded(
              child: Text(
                listener.obj.username ?? '',
                style: Theme.of(context).textTheme.titleMedium
              ),
            ),
            if(enableKickOut ?? true) ATContainer(
              onTap: ()async{
                final shouldKickOut = await showKickOutConfirmationDialog(
                  context: context,
                  title: 'Are you kicking out ${listener.obj.name}?',
                  content: ATStrings.KICK_OUT_DESC,
                  listener: listener
                );

                if((shouldKickOut ?? false) && context.mounted){
                  showAppNotification(
                    context: context,
                    icon: const ATImgLoader(imgPath: ATImgStrings.KICK_USER_OUT),
                    text: '${listener.obj.name} has been kicked out!',
                    bgColor: ATColors.hexECO404,
                  );
                }
              },
              height: 35, width: 35, boxShape: BoxShape.circle,
              color: ATColors.white.withOpacity(0.1),
              child: const ATImgLoader(
                boxFit: BoxFit.scaleDown,
                imgPath: ATImgStrings.KICK_USER_OUT
              ),
            )
          ],
        ),
      ),
    );
  }
}
