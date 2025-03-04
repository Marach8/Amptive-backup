import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:flutter/material.dart';
import '../../../../../../../utils/constants/font_sizes.dart';
import '../../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../widgets/common_widgets/app_bar_widget.dart';

class AmptiveCommunityTaskScreen extends StatelessWidget {
  const AmptiveCommunityTaskScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          padding: EdgeInsets.zero,
          leading: const Icon(Icons.keyboard_arrow_left),

          title: Text(
            AmptiveStrings.COMMUNITY_TASK,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AmptiveStrings.NO_TASK,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: AmptiveFontSizes.size16
                ),
              ),

              Text(
                maxLines: 2,
                AmptiveStrings.TASKS_WILL_APPEAR_HERE,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AmptiveColors.hexC2C2C2
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
