import 'dart:io';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CropPage extends StatefulWidget {

  const CropPage({
    super.key,
    required this.title,
    required this.imageFile,
  });
  final String title;
  final File imageFile;

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
          backgroundColor: ATColors.hex0D0D0D,
          elevation: 0.0,
          leadingWidth: 90.w,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 8.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 8.w),
                    width: 20.h,
                    height: 20.h,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ATColors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 3.w),
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      "Back",
                      style: GoogleFonts.inter(
                        color: ATColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          title: Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  width: 1.w,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final MemoryImage? image = await controller.onCropImage();
                  if (image != null && context.mounted) {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ResultScreen(image: image)));
                    context.pop(image);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ATColors.hex307FE2,
                ),
                child: Text(
                  "Apply",
                  style: GoogleFonts.inter(
                    color: ATColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: ATColors.hex0D0D0D,
        body: Column(
          children: <Widget>[
            Expanded(
              child: CustomImageCrop(
                  backgroundColor: ATColors.hex0D0D0D,
                  cropController: controller,
                  drawPath: drawCropPath,
                  image: FileImage(widget.imageFile)),
            ),
          ],
        ),
      ),
    );
  }

  CustomPaint drawCropPath(Path path, {Paint? pathPaint}) {
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
