import 'dart:io';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class RectImageCropperScreen extends StatefulWidget {

  const RectImageCropperScreen ({
    super.key, 
    required this.imageFile,
    this.ratio,
  });

  final File imageFile;
  final Ratio? ratio;

  @override
  State<RectImageCropperScreen > createState() => _CropPageState();
}

class _CropPageState extends State<RectImageCropperScreen > {
  late final CustomImageCropController controller;

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
                  const ATBackBtn(iconSize: 15),
                  const Spacer(),
                  ATContainer(
                    onTap: () async{
                      final MemoryImage? image = await controller.onCropImage();
                      if(context.mounted) context.pop(image);
                    },
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    color: ATColors.hex307FE2,
                    radius: 30,
                    child: Text(
                      ATStrings.APPLY,
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
                  shape: CustomCropShape.Ratio,
                  ratio: widget.ratio ?? Ratio(width: 16, height: 8),
                  drawPath: _drawCropPath,
                  image: FileImage(widget.imageFile)
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
    } 
    else {
      return CustomPaint(
        painter: SolidCropPathPainter(
          path,
          Paint()
            ..color = ATColors.trsprnt
            ..strokeWidth = 0
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round,
        ),
      );
    }
  }
}
