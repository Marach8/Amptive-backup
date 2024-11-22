import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

Map<String, Widget> mapOfOptions = {
  'Subscribe to glennodoyle': const Icon(Icons.favorite_border_outlined),
  'Follow glennodoyle': const Icon(Iconsax.user_tick4),
  'Share live': const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.SHARE_LIVE),
  'Not interested': const Icon(Icons.visibility_off_outlined),
  'Report': const Icon(Icons.flag_outlined)
};
