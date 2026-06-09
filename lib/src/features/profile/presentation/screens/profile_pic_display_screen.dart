import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../shared/app_bar_widget.dart';

class AmptiveViewProfilePicScreen extends StatelessWidget {
  const AmptiveViewProfilePicScreen({super.key, required this.imgPath});
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.close),
          ),
          leadingWidth: 30,
          actions: <Widget>[
            Text(ATStrings.edit, style: Theme.of(context).textTheme.bodyMedium),
          ],
          title: Text(
            ATStrings.PROFILE_PIC,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        body: Center(
          child: Hero(
            tag: imgPath,
            child: ATCircularImage(
              imagePath: imgPath,
              diameter: 250,
            ),
          ),
        ),
        bottomSheet: ATContainer(
          padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
          color: ATColors.white.withValues(alpha: 0.1),
          radius: 100,
          child: Text(ATStrings.SHARE_PROFILE,
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}
