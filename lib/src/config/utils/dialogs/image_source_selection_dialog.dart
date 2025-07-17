import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool?> showImageSourceOptions(BuildContext context) async{
  return await showCupertinoModalPopup<bool>(
    context: context,
    builder: (BuildContext dialogContext) => CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            ATStrings.PHOTO_GALLERY,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ATColors.hex307FE2,
            ),
          ),
          //We want to get from gallery
          onPressed: ()  => dialogContext.pop(true),
        ),
        CupertinoActionSheetAction(
          child: Text(
            ATStrings.CAMERA,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ATColors.hex307FE2,
            ),
          ),
          //We want to get from camera
          onPressed: ()  => dialogContext.pop(false),
        ),
      ],
    ),
  );
}