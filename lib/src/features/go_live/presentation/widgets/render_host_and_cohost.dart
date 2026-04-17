import 'dart:developer' show log;

import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/follow_and_subscribe_to_user_modal.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/other_strings.dart';

class RenderACohost extends StatelessWidget {
  const RenderACohost({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.cohost,
    required this.onTap,
  });

  final double? top, bottom, left, right;
  final LiveSessionParticipant? cohost;
  final ValueChanged<LiveSessionParticipant?> onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.decelerate,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => onTap(cohost),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                ATCircularImage(
                  diameter: 64,
                  addBorder: true,
                  borderColor: ATColors.white,
                  borderWidth: 1,
                  picturePadding: 2,
                  imagePath: cohost?.profilePicture ?? ''
                ),
                Positioned(
                  bottom: 0,
                  right: 5,
                  child: ATCircleAvatar(
                    diameter: 20,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Icon(
                        Icons.mic_off,
                        color: ATColors.hex0D0D0D,
                        size: 15,
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 80,
            child: Text(
              cohost?.name ?? '',
              textAlign: TextAlign.center,
              style: context.textTheme.titleSmall,
            ),
          ),
        ],
      )
    );
  }
}




class RenderAHost extends StatelessWidget {
  const RenderAHost({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.host,
    this.onTap,
  });

  final double? top, bottom, left, right;
  final LiveSessionParticipant? host;
  final void Function(LiveSessionParticipant? host)? onTap;

  @override
  Widget build(BuildContext context) {
    log('This is the host picture ${host?.profilePicture}');
    log('This is the host username ${host?.username}');
    log('This is the host name ${host?.name}');
    log('This is the host id ${host?.userId}');
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.decelerate,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: GestureDetector(
        onTap: (){
          if(onTap != null){
            onTap!(host);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                ATCircularImage(
                  diameter: 94,
                  addBorder: true,
                  borderColor: ATColors.white,
                  borderWidth: 1,
                  picturePadding: 2,
                  imagePath: host?.profilePicture ?? ''
                ),
                Positioned(
                  bottom: 0,
                  right: 5,
                  child: ATCircleAvatar(
                    diameter: 20,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Icon(
                        Icons.mic_off,
                        color: ATColors.hex0D0D0D,
                        size: 15
                      )
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 80,
              child: Text(
                host?.username ?? '',
                textAlign: TextAlign.center,
                style: context.textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    ATColors.hexF91880,
                    ATColors.orangeGradientColorB
                  ]
                ),
              ),
              child: Text(
                ATStrings.host.toUpperCase(),
                  style: context.textTheme.bodySmall
                    ?.copyWith(
                      fontSize: ATSizes.size10,
                    )
                  ),
                )
          ],
        ),
      )
    );
  }
}



class HostAddCohostIcon extends StatelessWidget {
  const HostAddCohostIcon({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.onTap,
  });

  final double? top, bottom, left, right;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
              Container(
              height: 64, width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: ATColors.white.withValues(alpha: 0.2),
                  width: 2
                ),
              ),
              child: const Icon(Icons.add, size: 40)
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 80,
              child: Text(
                ATStrings.addCohost.toLowerCase(),
                textAlign: TextAlign.center,
                style: context.textTheme.titleSmall?.copyWith(height: 0.8),
              ),
            ),
          ],
        ),
      )
    );
  }
}
