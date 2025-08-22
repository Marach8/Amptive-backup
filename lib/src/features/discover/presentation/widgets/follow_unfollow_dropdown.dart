import 'dart:ui';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';

class FollowUnfollowDropDown extends StatelessWidget {
  const FollowUnfollowDropDown({
    super.key,
    required this.child,
    required this.onSelected,
    required this.text,
    required this.popUpTrailingIcon,
  });

  final Widget child, popUpTrailingIcon;
  final String text;
  final void Function(String)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: Offset(context.screenWidth, 30),
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      onSelected: onSelected,
      color: ATColors.trsprnt,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: child,      
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          height: 44,
          padding: EdgeInsets.zero,
          value: text,
          child: ATContainer(
            padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
            clipBehavior: Clip.hardEdge,
            radius: 12, height: 44,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    text,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: 50,),
                  popUpTrailingIcon
                ],
              ),
            ),
          )
        )
      ]
    );
  }
}