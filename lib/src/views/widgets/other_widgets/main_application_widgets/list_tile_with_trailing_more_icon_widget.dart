import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/png_jpeg_asset_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveListTileWithTrailingMoreIconWidget extends StatelessWidget {
  const AmptiveListTileWithTrailingMoreIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      trailing: GestureDetector(
        onTap: (){},
        child: const Icon(Icons.more_horiz)
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AmptivePngAndJpegAssetLoaderWidget(
          pngOrJpegPath: AmptiveImageStrings.jpeg1,
          boxFit: BoxFit.cover,
          height: 30.h,
          width: 30.w,
        ),
      ),
      title: Text(
        'emmanuelnnanna',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: AmptiveFontWeights.medium
        ),
      ),
      subtitle: Text(
        'emmanuelnnanna',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: AmptiveFontWeights.medium
        ),
      ),
    );
  }
}
