import 'dart:async';
import 'dart:io';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/after_route_transition.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:custom_image_crop/custom_image_crop.dart'
    show Ratio, CustomCropShape;
import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/prepared_cover_art.dart';
import '../../../../shared/custom_container_widget.dart';
import 'cover_image_picker_sheet.dart';

class SelectProgramCoverArt extends StatefulWidget {
  const SelectProgramCoverArt({
    super.key,
    required this.onImageSelected,
    this.onImageUrlSelected,
    this.onImageAndUrlSelected,
    this.initialImage,
  });

  final void Function(Uint8List) onImageSelected;
  final void Function(String)? onImageUrlSelected;
  final void Function(String, Uint8List)? onImageAndUrlSelected;
  final String? initialImage;

  @override
  State<SelectProgramCoverArt> createState() => _SelectProgramCoverArtState();
}

class _SelectProgramCoverArtState extends State<SelectProgramCoverArt> {
  Uint8List? selectedImgBytes;
  String? selectedCoverPath;

  @override
  void initState() {
    super.initState();
    // New shows/events open with the pre-warmed random cover — its image and
    // colors were prepared before navigation, so the form's first frame is
    // already complete. The user can still tap to swap it out. Edit flows
    // pass initialImage and keep their existing cover.
    if (widget.initialImage == null) {
      final String coverPath = PreparedCoverArt.path;
      final Uint8List? preparedBytes = PreparedCoverArt.bytes;
      selectedCoverPath = coverPath;
      selectedImgBytes = preparedBytes;
      // After the slide-in settles: hand the bytes to the form and start
      // warming the next visit's cover. Doing either mid-transition would
      // steal frame time from the animation.
      runAfterRouteTransition(context, () {
        if (!mounted) return;
        if (preparedBytes != null) {
          widget.onImageSelected(preparedBytes);
        } else {
          unawaited(_prepareCoverBytes(coverPath));
        }
        PreparedCoverArt.consumeAndPrepareNext();
      });
    }
  }

  void _applyCuratedCover(String imagePath) {
    widget.onImageUrlSelected?.call(imagePath);
    setState(() {
      selectedCoverPath = imagePath;
      selectedImgBytes = null;
    });
    unawaited(_prepareCoverBytes(imagePath));
  }

  Future<void> _prepareCoverBytes(String imagePath) async {
    final Uint8List bytes = await loadCoverArtBytes(imagePath);
    if (!mounted || selectedCoverPath != imagePath) return;
    setState(() {
      widget.onImageSelected(bytes);
      selectedImgBytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: 10,
        cornerSmoothing: 0.8,
      ),
      child: ATContainer(
        radius: 0,
        color: ATColors.transparent,
        onTap: () async {
          FocusScope.of(context).unfocus(disposition: UnfocusDisposition.scope);
          final CoverImagePickerResult? selection =
              await showCoverImagePickerSheet(
            context,
            onCoverSelected: _applyCuratedCover,
          );
          if (!context.mounted || selection == null) return;

          if (selection.assetPath != null) {
            final String imagePath = selection.assetPath!;
            widget.onImageUrlSelected?.call(imagePath);
            final Uint8List bytes = await loadCoverArtBytes(imagePath);
            if (!context.mounted) return;
            setState(() {
              widget.onImageSelected(bytes);
              selectedImgBytes = bytes;
            });
            return;
          }

          final ImageSource? selectedSrc = selection.source;
          final XFile? selectedFile =
              await ATHelperFuncs.pickImage(selectedSrc);
          if (context.mounted && selectedFile != null) {
            final File file = File(selectedFile.path);
            // Decode the picked image up front so the cropper renders it the
            // instant it opens, instead of decoding after the screen appears.
            if (context.mounted) {
              await precacheImage(FileImage(file), context);
            }
            if (!context.mounted) return;
            final MemoryImage? croppedImage = await context
                .pushNamed(ATRoutes.rectImageCropperScreen, extra: (
              file,
              Ratio(width: 160, height: 160),
              CustomCropShape.Ratio,
            ));

            if (croppedImage != null) {
              if (widget.onImageAndUrlSelected != null) {
                widget.onImageAndUrlSelected!(
                    ATImgStrings.createShowPlaceholder, croppedImage.bytes);
              } else {
                widget.onImageUrlSelected
                    ?.call(ATImgStrings.createShowPlaceholder);
                widget.onImageSelected(croppedImage.bytes);
              }
              setState(() {
                selectedCoverPath = null;
                selectedImgBytes = croppedImage.bytes;
              });
            }
          }
        },
        height: 160,
        width: 160,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ((selectedCoverPath ?? widget.initialImage) != null &&
                    ((selectedCoverPath ?? widget.initialImage)!
                            .startsWith('http') ||
                        (selectedCoverPath ?? widget.initialImage)!
                            .startsWith('assets')))
                ? ATImgLoader(
                    imgPath: selectedCoverPath ?? widget.initialImage!,
                    boxFit: BoxFit.cover,
                    height: 160,
                    width: 160,
                  )
                : (selectedImgBytes != null
                    ? Image.memory(
                        selectedImgBytes!,
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      )
                    : const ATImgLoader(
                        imgPath: ATImgStrings.createShowPlaceholder,
                        boxFit: BoxFit.cover,
                        height: 160,
                        width: 160,
                      )),
            CircleAvatar(
                backgroundColor: ATColors.black.withValues(alpha: 0.5),
                radius: 20,
                child: const ATImgLoader(
                    imgPath: ATImgStrings.addImageIcon, height: 20, width: 20)),
          ],
        ),
      ),
    );
  }
}
