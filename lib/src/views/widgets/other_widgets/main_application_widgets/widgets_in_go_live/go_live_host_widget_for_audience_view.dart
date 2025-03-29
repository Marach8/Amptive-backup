import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/dialogs/go_live/follow_or_subscribe_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../models/host.dart';
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';

class AmptiveLiveHostAndCoHostWidgetForAudienceView extends StatelessWidget {
  final double? top, bottom, left, right;
  final ObjectWithNotifier<Host>? hostOrCohost;
  final GoLiveService service;
  final bool isHost;
  final int index;
  final Function(ObjectWithNotifier<Host>? host) onTap;

  const AmptiveLiveHostAndCoHostWidgetForAudienceView(
      {super.key,
      this.top,
      this.bottom,
      this.left,
      this.right,
      required this.hostOrCohost,
      this.isHost = false,
      required this.onTap,
      required this.service,
      required this.index});

  @override
  Widget build(context) {
    return AnimatedPositioned(
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: hostOrCohost?.obj.profilePicture == null
            ? const SizedBox()
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (hostOrCohost != null) {
                        showFollowHostOrCohostDialog(
                            context: context, host: hostOrCohost!);
                      }
                      onTap(hostOrCohost);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        ATCircularImage(
                            diameter: isHost ? 94.h : 64.h,
                            addBorder: true,
                            borderColor: ATColors.white,
                            borderWidth: 1,
                            picturePadding: 2,
                            imagePath: hostOrCohost?.obj.profilePicture ?? ''),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: ATCircleAvatar(
                            diameter: 20.h,
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Icon(
                                  Icons.mic_off,
                                  color: ATColors.brandBlack,
                                  size: 15.h,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(5.h),
                  SizedBox(
                    width: 80.w,
                    child: Text(
                      hostOrCohost?.obj.name ?? '',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Gap(5.h),
                  isHost
                      ? ATContainer(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                          radius: 5,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ATColors.orangeGradientColorB,
                                ATColors.orangeGradientColorB
                              ]),
                          child: Text(ATStrings.HOST.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: ATFontSizes.size10,
                                  )),
                        )
                      : const SizedBox.shrink()
                ],
              ));
  }
}
