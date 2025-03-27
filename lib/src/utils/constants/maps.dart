import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';

Map<String, Widget> mapOfOptions = {
  'Subscribe to glennodoyle': const Icon(Icons.favorite_border_outlined),
  'Follow glennodoyle': const ATImgLoader(imgPath: ATImgStrings.FOLLOW_ICON),
  'Share live': const ATImgLoader(imgPath: ATImgStrings.SHARE_LIVE),
  'Not interested': const Icon(Icons.visibility_off_outlined),
  'Report': const Icon(Icons.flag_outlined)
};
