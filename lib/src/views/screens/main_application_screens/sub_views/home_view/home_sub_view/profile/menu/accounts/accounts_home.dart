import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/profile/menu/profile_menu_screen.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../../../../bloc/main_app/profile/private_account_bloc.dart';
import '../../../../../../../../../bloc/main_app/profile/profile_menu/language_bloc.dart';
import '../../../../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../../../../utils/constants/strings/route_strings.dart';
import '../../../../../../../../../utils/dialogs/app_notification_dialog.dart';
import '../../../../../../../../widgets/common_widgets/circle_avatar.dart';
import '../../../../../../../../widgets/common_widgets/switch_widget.dart';



class ATAccountScreen extends StatelessWidget {
  const ATAccountScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 15),
              child: Row(
                children: [
                  AmptiveCircleAvatarWidget(
                    onTap: () => context.pop(),
                    diameter: 30, color: ATColors.trsprtColor,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const Spacer(),
                  Text(
                    ATStrings.ACCT,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_left, color: ATColors.trsprtColor),
                ],
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}