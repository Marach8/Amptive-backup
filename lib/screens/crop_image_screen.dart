import 'dart:io';

import 'package:amptive/utils/common_widgets.dart';
import 'package:amptive/utils/utils.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CropPage extends StatefulWidget {
  final String title;
  final File imageFile;

  const CropPage({
    Key? key,
    required this.title,
    required this.imageFile,
  }) : super(key: key);

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  late CustomImageCropController controller;

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AmpColors.brandBlack,
          elevation: 0.0,
          leadingWidth: 90.w,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 8.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8.w),
                    width: 20.h,
                    height: 20.h,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: AmpColors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 3.w),
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      "Back",
                      style: GoogleFonts.inter(
                        color: AmpColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 1.w,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Apply",
                      style: GoogleFonts.inter(
                        color: AmpColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        backgroundColor: AmpColors.brandBlack,
        body: Column(
          children: [
            Expanded(
              child: CustomImageCrop(
                  backgroundColor: AmpColors.brandBlack,
                  cropController: controller,
                  drawPath: drawCropPath,
                  image: FileImage(widget.imageFile)),
            ),
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: controller.reset),
                IconButton(
                    icon: const Icon(Icons.zoom_in),
                    onPressed: () =>
                        controller.addTransition(CropImageData(scale: 1.33))),
                IconButton(
                    icon: const Icon(Icons.zoom_out),
                    onPressed: () =>
                        controller.addTransition(CropImageData(scale: 0.75))),
                // IconButton(icon: const Icon(Icons.rotate_left), onPressed: () => controller.addTransition(CropImageData(angle: -pi / 4))),
                // IconButton(icon: const Icon(Icons.rotate_right), onPressed: () => controller.addTransition(CropImageData(angle: pi / 4))),
                IconButton(
                  icon: const Icon(Icons.crop),
                  onPressed: () async {
                    final image = await controller.onCropImage();
                    if (image != null && mounted) {
                      // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ResultScreen(image: image)));
                      context.pop(image);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  static CustomPaint drawCropPath(Path path, {Paint? pathPaint}) {
    if (pathPaint != null) {
      return CustomPaint(
        painter: SolidCropPathPainter(path, pathPaint),
      );
    } else {
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
