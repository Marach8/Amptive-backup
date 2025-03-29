import 'dart:io';

import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/image_source_selection_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';


class EditProfileBgImage extends StatelessWidget {
  const EditProfileBgImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    return StatefulBuilder(
      builder: (context, setter) {
        return GestureDetector(
          onTap: () async{
            File? file;
            final status = await showImageSourceOptions(context);
            if(status == null){return;}
            else if(context.mounted && status){
              file = await ATHelperFuncs.getImageFromGallery();
            }
            else if(context.mounted){
              file = await ATHelperFuncs.getImageFromCamera();
            }
    
            if(file == null) return;
            if(context.mounted){
              final imageData = await context
                .pushNamed(ATRoutes.PROFILE_BG_CROP, extra: file) as MemoryImage?;
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
        );
      }
    );
  }
}