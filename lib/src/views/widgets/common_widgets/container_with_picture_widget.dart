import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/png_jpeg_asset_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveCircularContainerWithPIctureWidget extends StatelessWidget {
  final String imagePath;
  const AmptiveCircularContainerWithPIctureWidget({
    super.key,
    required this.imagePath
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1).r,
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AmptiveColors.whiteColor,
          width: 0.5
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AmptivePngAndJpegAssetLoaderWidget(
          pngOrJpegPath: imagePath,
          boxFit: BoxFit.cover,
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
