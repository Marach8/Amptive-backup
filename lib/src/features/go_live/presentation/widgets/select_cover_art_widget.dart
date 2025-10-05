import 'dart:io';
import 'dart:typed_data';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/image_source_selection_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:custom_image_crop/custom_image_crop.dart' show Ratio;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/custom_container_widget.dart';

class SelectProgramCoverArt extends StatefulWidget {
  const SelectProgramCoverArt({
    super.key,
    required this.onImageSelected,
  });

  final void Function(Uint8List) onImageSelected;

  @override
  State<SelectProgramCoverArt> createState() => _SelectProgramCoverArtState();
}

class _SelectProgramCoverArtState extends State<SelectProgramCoverArt> {
  Uint8List? selectedImgBytes;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      radius: 10,
      clipBehavior: Clip.hardEdge,
      color: ATColors.transparent,
      onTap: ()async{
        final ImageSource? selectedSrc = await showImageSourceOptions(context);
        final XFile? selectedFile = await ATHelperFuncs.pickImage(selectedSrc);
        if(context.mounted && selectedFile != null){
          final File file = File(selectedFile.path);
          final MemoryImage? croppedImage = await context.pushNamed(
            ATRoutes.RECT_IMG_CROPPER_SCREEN, extra: (file, Ratio(width: 160, height: 160))
          );

          if(croppedImage != null){
            setState(() {
              widget.onImageSelected(croppedImage.bytes);
              selectedImgBytes = croppedImage.bytes;
            });
          }
        }
      },
      height: 160, width: 160,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          selectedImgBytes == null ? const ATImgLoader(
            imgPath: ATImgStrings.CREATE_SHOW_PLACEHOLDER,
            boxFit: BoxFit.cover,
          ) : Image.memory(
            height: 160, width: 160,
            selectedImgBytes!,
            fit: BoxFit.cover,
          ),

          CircleAvatar(
            backgroundColor: ATColors.black.withValues(alpha: 0.5),
            radius: 20,
            child: const ATImgLoader(
              imgPath: ATImgStrings.ADD_IMAGE_ICON,
              height: 20, width: 20
            )
          ),
        ],
      ),
    );
  }
}
