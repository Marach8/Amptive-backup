import 'dart:ui';

import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/routes.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/add_co_host_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/horiz_slider_animation.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../../services/create_show/create_show_service.dart';
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import 'dart:developer' as marach show log;

class AmptiveLiveHostAndCoHostWidget extends StatelessWidget {
  final double? top, bottom, left, right;
  final ObjectWithNotifier<Host> hostOrCohost;
  final GoLiveService service;
  final bool isHost, removeCohost;
  final int index;
  final Function(ObjectWithNotifier<Host>? host) onTap;
  const AmptiveLiveHostAndCoHostWidget({
    super.key,
    this.top, this.bottom,
    this.left, this.right,
    required this.hostOrCohost,
    this.isHost = false,
    this.removeCohost = false,
    required this.onTap,
    required this.service,
    required this.index
  });

  @override
  Widget build(context) {
    final showAddIcon = hostOrCohost.obj.profilePicture == null;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      top: top, left: left, right: right, bottom: bottom,
      child: removeCohost ? const SizedBox.shrink() : GestureDetector(
        onTap: () async{
          
          if(index != 0){
            if(showAddIcon){
              await showModalBottomSheet<ObjectWithNotifier<Host>>(
                context: context,
                builder: (_){
                  return AmptiveCustomContainer(
                    clipBehavior: Clip.hardEdge,
                    height: AmptiveHelperFunctions.getScreenHeight(context) * 0.5,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: service.coHostsListData.getRange(
                            1, service.coHostsListData.length
                          ).map(
                            (coHost){
                              return AmptiveCoHostWidget(
                                onTap:(host, isSelected){
                                  if(isSelected){
                                    final index2Remove = service.goLiveHostListNotifier.value.toList().indexWhere(
                                      (aHost) => aHost.obj.profilePicture == host.obj.profilePicture
                                    );
                                    service.hostRemoveCohost(coHost, index2Remove);
                                    context.pop();
                                  }
                                  else{
                                    service.hostAddCohost(coHost, index);
                                    context.pop();
                                  }
                                },
                                coHostDetail: coHost
                              );
                            }
                          ).toList()
                        ),
                      ),
                    ),
                  );
                }
              );
            }

            else{
              service.hostRemoveCohost(hostOrCohost, index);
            }
          }
          onTap(hostOrCohost);
        },
        child : Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            showAddIcon ? AmptiveCustomContainer(
              height: 64.h, width: 64.h, radius: 40.h,
              border: Border.all(color: AmptiveColors.whiteColor, width: 0.5),
              child: const Icon(Icons.add, size: 40)) 
            : Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AmptiveCircularContainerWithPictureWidget(
                  diameter: isHost ? 94.h : 64.h, addBorder: true,
                  borderColor: AmptiveColors.whiteColor,
                  borderWidth: 1, picturePadding: 2,
                  imagePath: hostOrCohost.obj.profilePicture ?? ''
                ),
                Positioned(
                  bottom: 0, right: 5,
                  child: AmptiveCirceAvatarWidget(
                    diameter: 20.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Icon(
                        Icons.mic_off, color: AmptiveColors.brandBlackColor,
                        size: 15.h,
                      )
                    ),
                  ),
                ),
              ],
            ),
            Gap(5.h),
            SizedBox(
              width: 80.w,
              child: Text(
                hostOrCohost.obj.name ?? AmptiveOtherStrings.ADD_CO_HOST.toLowerCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Gap(5.h),
            isHost ? AmptiveCustomContainer(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              radius: 5, 
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AmptiveColors.orangeGradientColorA,
                  AmptiveColors.orangeGradientColorB
                ]
              ),
              child: Text(
                AmptiveOtherStrings.HOST.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: AmptiveFontSizes.size10,
                )
              ),
            ) : const SizedBox.shrink()
          ],
        ),
      )
    );
  }
}