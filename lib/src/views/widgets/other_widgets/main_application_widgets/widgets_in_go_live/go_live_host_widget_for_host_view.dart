import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../utils/dialogs/go_live/go_live_add_cohost_dialog.dart';
import '../../../common_widgets/circle_avatar.dart';

class AmptiveLiveHostAndCoHostWidget extends StatelessWidget {
  final double? top, bottom, left, right;
  final ObjectWithNotifier<Host>? hostOrCohost;
  final GoLiveService service;
  final bool isHost;
  final int index;
  final Function(ObjectWithNotifier<Host>? host) onTap;
  const AmptiveLiveHostAndCoHostWidget({
    super.key,
    this.top, this.bottom,
    this.left, this.right,
    required this.hostOrCohost,
    this.isHost = false,
    required this.onTap,
    required this.service,
    required this.index
  });

  @override
  Widget build(context) {
    final showAddIcon = hostOrCohost?.obj.profilePicture == null;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      top: top, left: left, right: right, bottom: bottom,
      child: GestureDetector(
        onTap: () async{
          
          /// If We did not tap on the Host
          if(index != 0){
            if(showAddIcon){
              await showGoLiveHostAddCoHostDialog(context: context);
            }
            else{
              context.read<AmptiveGoLiveSelectCoHostBloc>().hostRemoveCohostWithIndex(hostOrCohost, index-1);
            }
          }
          onTap(hostOrCohost);
        },
        child : Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            showAddIcon ? ATContainer(
              height: 64.h, width: 64.h, radius: 40.h,
              border: Border.all(color: ATColors.white, width: 0.5),
              child: const Icon(Icons.add, size: 40)) 
            : Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AmptiveCircularContainerWithPictureWidget(
                  diameter: isHost ? 94.h : 64.h, addBorder: true,
                  borderColor: ATColors.white,
                  borderWidth: 1, picturePadding: 2,
                  imagePath: hostOrCohost?.obj.profilePicture ?? ''
                ),
                Positioned(
                  bottom: 0, right: 5,
                  child: AmptiveCircleAvatarWidget(
                    diameter: 20.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Icon(
                        Icons.mic_off, color: ATColors.brandBlack,
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
                hostOrCohost?.obj.name ?? ATStrings.ADD_CO_HOST.toLowerCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Gap(5.h),
            isHost ? ATContainer(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              radius: 5, 
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ATColors.orangeColor1,
                  ATColors.orangeGradientColorB
                ]
              ),
              child: Text(
                ATStrings.HOST.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATFontSizes.size10,
                )
              ),
            ) : const SizedBox.shrink()
          ],
        ),
      )
    );
  }
}
