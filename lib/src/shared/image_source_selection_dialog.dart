import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> showImageSourceOptions(
  BuildContext context) async {
    return await showCupertinoModalPopup<ImageSource?>(
      context: context,
      builder: (BuildContext dialogContext) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              ATStrings.photoGallery,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: ATColors.hex307FE2,
              ),
            ),
            //We want to get from gallery
            onPressed: () => Navigator.pop(
              dialogContext, ImageSource.gallery),
          ),
          CupertinoActionSheetAction(
            child: Text(
              ATStrings.camera,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: ATColors.hex307FE2,
              ),
            ),
            //We want to get from camera
            onPressed: () => Navigator.pop(
              dialogContext, ImageSource.camera),
          ),
        ],
      ),
    );
}
