import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../views/widgets/common_widgets/back_button.dart';

class AmptiveCommunityTaskScreen extends StatelessWidget {
  const AmptiveCommunityTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leadingWidth: 30,
          padding: EdgeInsets.only(left: 7),
          leading: ATRoundedBackBtn(),
          titleText: ATStrings.SWITCH_ACCT
        ),

        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ATStrings.COMMUNITY_TASK,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: ATSizes.size16
                ),
              ),

              Text(
                maxLines: 2,
                ATStrings.TASKS_WILL_APPEAR_HERE,
                style: context.textTheme.titleMedium?.copyWith(
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
