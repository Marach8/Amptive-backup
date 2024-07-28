import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/container_with_picture_widget.dart';
import 'package:flutter/material.dart';

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
      leading: const AmptiveCircularContainerWithPIctureWidget(
        imagePath: AmptiveImageStrings.jpeg3,
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
