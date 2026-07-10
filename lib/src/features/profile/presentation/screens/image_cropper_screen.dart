import 'dart:io';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageCroppingParams{
  const ImageCroppingParams({
    required this.imageFile,
    this.shape = CustomCropShape.Ratio,
    this.ratio,
  });

  final File imageFile;
  final Ratio? ratio;
  final CustomCropShape shape;
}


class ImageCropperScreen extends StatefulWidget {
  const ImageCropperScreen({
    super.key,
    required this.params,
  });
  final ImageCroppingParams params;

  @override
  State<ImageCropperScreen> createState() => _CropPageState();
}

class _CropPageState extends State<ImageCropperScreen> {
  late final CustomImageCropController controller;
  bool _cropping = false;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Row(
                children: <Widget>[
                  const ATBackBtn(),
                  const Spacer(),
                  ATContainer(
                    onTap: _cropping
                        ? null
                        : () async {
                            setState(() => _cropping = true);
                            final MemoryImage? image =
                                await controller.onCropImage();
                            if (context.mounted) context.pop(image);
                          },
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    color: const Color(0xFFFF0078),
                    radius: 30,
                    child: _cropping
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            ATStrings.apply,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: CustomImageCrop(
                  backgroundColor: ATColors.black,
                  cropController: controller,
                  cropPercentage: 1,
                  imageFit: CustomImageFit.fitVisibleSpace,
                  shape: widget.params.shape,
                  ratio: widget.params.shape == CustomCropShape.Ratio
                      ? (widget.params.ratio ?? Ratio(width: 16, height: 8))
                      : null,
                  drawPath: _drawCropPath,
                  image: FileImage(widget.params.imageFile),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomPaint _drawCropPath(Path path, {Paint? pathPaint}) {
    if (pathPaint != null) {
      return CustomPaint(
        painter: SolidCropPathPainter(path, pathPaint),
      );
    } else {
      return CustomPaint(
        painter: SolidCropPathPainter(
          path,
          Paint()
            ..color = ATColors.transparent
            ..strokeWidth = 0
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round,
        ),
      );
    }
  }
}
