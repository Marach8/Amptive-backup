import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/font_sizes.dart';
import '../../../../utils/constants/strings/other_strings.dart';

class AmptiveCommunityTaskScreen extends StatelessWidget {
  const AmptiveCommunityTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          padding: EdgeInsets.zero,
          leading: const Icon(Icons.keyboard_arrow_left),

          title: Text(
            ATStrings.COMMUNITY_TASK,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ATStrings.NO_TASK,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATFontSizes.size16
                ),
              ),

              Text(
                maxLines: 2,
                ATStrings.TASKS_WILL_APPEAR_HERE,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ATColors.hexC2C2C2
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
