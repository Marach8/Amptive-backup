import 'dart:io';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/image_source_selection_dialog.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart' show ImageSource, XFile;


class EditProfileBgImage extends StatelessWidget {
  const EditProfileBgImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function())  setter) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            GestureDetector(
              onTap: () async{
                final ImageSource? selectedSrc = await showImageSourceOptions(context);
                final XFile? selectedFile = await ATHelperFuncs.pickImage(selectedSrc);
                if(context.mounted && selectedFile != null){
                  final File file = File(selectedFile.path);
                  final MemoryImage? imageData = await context.pushNamed(ATRoutes.RECT_IMG_CROPPER_SCREEN, extra: file) as MemoryImage?;
                  if(imageData != null){
                    setter(() => imageBytes = imageData.bytes);
                  }
                }
              },
              child: imageBytes == null ? ATImgLoader(
                height: 150, boxFit: BoxFit.cover,
                width: ATHelperFuncs.getScreenWidth(context),
                imgPath: ATImgStrings.weCanDoHardThingsBgImage
              ) : Image.memory(
                imageBytes!,
                //frameBuilder: ,
                height: 150, fit: BoxFit.cover,
                width: ATHelperFuncs.getScreenWidth(context),
              )
            ),
            Positioned(
              bottom: -35,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.center,
                children: <Widget>[
                  ATCircularImage(
                    onTap: () => context.pushNamed(
                      ATRoutes.PROFILE_PIC_SCREEN,
                      extra: ATImgStrings.jpeg2
                    ),
                    diameter: 70, addBorder: true,
                    borderColor: ATColors.black,
                    borderWidth: 3,
                    imagePath: ATImgStrings.jpeg2
                  ),
                  ATContainer(
                    height: 67, width: 67,
                    boxShape: BoxShape.circle,
                    color: ATColors.black.withValues(alpha: 0.5),
                    child: const Icon(Icons.add_photo_alternate_outlined)
                  )
                ],
              )
            ),
          ],
        );
      }
    );
  }
}