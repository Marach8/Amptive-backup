import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../widgets/common_widgets/app_bar_widget.dart';


class AmptiveViewProfilePicScreen extends StatelessWidget {
  const AmptiveViewProfilePicScreen({super.key, required this.imgPath});
  final String imgPath;

  @override
  Widget build(context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.close),
          ),
          leadingWidth: 30,
          actions: [
            Text(
              AmptiveStrings.EDIT,
              style: Theme.of(context).textTheme.bodyMedium
            ),
          ],
          title: Text(
            AmptiveStrings.PROFILE_PIC,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: Center(
          child: Hero(
            tag: imgPath,
            child: AmptiveCircularContainerWithPictureWidget(
              imagePath: imgPath,
              diameter: 250,
            ),
          ),
        ),
        bottomSheet: AmptiveContainer(
          padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
          color: AmptiveColors.whiteColor.withValues(alpha: 0.1),
          radius: 100,
          child: Text(
            AmptiveStrings.SHARE_PROFILE,
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
      ),
    );
  }
}
