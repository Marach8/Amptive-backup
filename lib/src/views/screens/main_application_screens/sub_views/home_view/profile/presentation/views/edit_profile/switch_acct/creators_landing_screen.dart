import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatorLandingScreen extends StatelessWidget {
  const CreatorLandingScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: StatefulBuilder(
        builder: (_, setter) {
          return Scaffold(
            appBar: const ATAppBar(
              leadingWidth: 30,
              padding: EdgeInsets.only(left: 7),
              leading: ATRoundedBackBtn(),
              titleText: ATStrings.SWITCH_ACCT
            ),
          
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Column(
                children: [

                ],
              ),
            ),
          
            bottomSheet: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: ATPlainElevatedBtn(
                onPressed: () => context.pushNamed(ATRoutes.CREATOR_LANDING),
                btnTitle: ATStrings.PROCEED,
              ),
            ),
          );
        }
      ),
    );
  }
}