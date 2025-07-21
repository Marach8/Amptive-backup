import 'dart:io';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CircleImageCropperScreen extends StatefulWidget {

  const CircleImageCropperScreen({
    super.key,
    required this.imageFile,
  });
  final File imageFile;

  @override
  State<CircleImageCropperScreen> createState() => _CircleImageCropperScreenState();
}

class _CircleImageCropperScreenState extends State<CircleImageCropperScreen> {
  late final CustomImageCropController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomImageCropController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      backgroundColor: ATColors.hex0D0D0D,
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
                      final MemoryImage? image = await _controller.onCropImage();
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
              child: CustomImageCrop(
                backgroundColor: ATColors.hex0D0D0D,
                cropController: _controller,
                drawPath: _drawCropPath,
                image: FileImage(widget.imageFile)
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
            ..color = ATColors.trsprnt
            ..strokeWidth = 0
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round,
        ),
      );
    }
  }
}
