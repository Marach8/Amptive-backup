import 'dart:io';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../../widgets/common_widgets/elevated_button_widget.dart';

class CropProfileBgImageScreen extends StatefulWidget {

  const CropProfileBgImageScreen ({super.key, required this.file});
  final File file;

  @override
  State<CropProfileBgImageScreen > createState() => _CropPageState();
}

class _CropPageState extends State<CropProfileBgImageScreen > {
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
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, kToolbarHeight * 0.3, 15, 0),
              child: Row(
                children: [
                  const ATBackBtn(iconSize: 15),
                  const Spacer(),
                  ATContainer(
                    onTap: () async{
                      final image = await controller.onCropImage();
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
                  ratio: Ratio(width: 16, height: 8),
                  drawPath: _drawCropPath,
                  image: FileImage(widget.file)
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
            ..color = Colors.transparent
            ..strokeWidth = 0
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round,
        ),
      );
    }
  }
}
