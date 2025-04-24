import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/otp_fields_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:developer';

class ATSecurityQuestionScreen extends StatelessWidget {
  const ATSecurityQuestionScreen({super.key});

  @override
  Widget build(_) {
    return ATAnnotatedRegion(
      child: Builder(
        builder: (context) {
      
          return Scaffold(
            appBar: const ATAppBar(
              leading: ATRoundedBackBtn(),
              leadingWidth: 30,
              padding: EdgeInsets.only(left: 7),
              titleText: ATStrings.WALLET_SETUP,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),

            bottomSheet: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: ATPlainElevatedBtn(
                onPressed: (){},
                btnTitle: ATStrings.ADD_SECURITY_QUESTION
              ),
            ),
          );
        }
      ),
    );
  }
}
