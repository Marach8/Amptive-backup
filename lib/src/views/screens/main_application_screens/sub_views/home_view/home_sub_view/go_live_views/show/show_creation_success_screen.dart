import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../../utils/constants/colors.dart';
import '../../../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../../../utils/constants/strings/route_strings.dart';
import '../../../../../../../widgets/common_widgets/elevated_button_widget.dart';

class AmptiveCreateShowSuccessScreen extends StatelessWidget {
  const AmptiveCreateShowSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          leadingWidth: 20,
          leading: GestureDetector(
            onTap: (){context.pop();},
            child: const Icon(Icons.arrow_back_ios_new_outlined, size: 17,)
          ),
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.check_circle_sharp, size: 45),
              const Gap(15),
              Text(
                textAlign: TextAlign.center,
                AmptiveOtherStrings.SHOW_IS_SETUP,
                style: Theme.of(context).textTheme.headlineLarge
              ),
              const Gap(10),

              Text(
                textAlign: TextAlign.center,
                AmptiveOtherStrings.BEGIN_JOURNEY,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AmptiveColors.subtitleColor
                ),
              ),
              const Gap(30),
              const AmptiveImageLoaderWidget(
                imagePath: AmptiveImageStrings.JOE_POMP_SHOW,
                height: 140, width: 140,
              )
            ],
          ),
        ),

        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AmptiveElevatedButtonWidget(
              onPressed: () async{
                await context.pushNamed(AmptiveRoutes.CREATE_EPISODE_FORM);
              },
              buttonTitle: AmptiveOtherStrings.CREATE_1ST_EPISODE,
              bgColor: AmptiveColors.whiteColor,
              fgColor: AmptiveColors.black,
            ),
            const Gap(10),
            Text(
              AmptiveOtherStrings.VIEW_SHOW_PAGE,
              style: Theme.of(context).textTheme.headlineMedium
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}